// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:cli/glyph_name.dart';
import 'package:cli/glyph_range.dart';
import 'package:cli/smufl_code_generator.dart';

enum Metadata {
  range("ranges.json"),
  glyphNames("glyphnames.json"),
  classes("classes.json");

  const Metadata(this.fileName);

  final String fileName;
  String get downloadLink => "$repo$fileName";
  String get filePath => "$localFolder/$fileName";

  static const repo =
      "https://raw.githubusercontent.com/w3c/smufl/gh-pages/metadata/";

  static const localFolder = "../tools/metadata";
}

const metaFilename = "meta.txt";

/// Record current date in a provided [folder], in [metaFilename].
Future recordDate(String folder) async {
  String formattedDate = DateTime.now().toIso8601String();

  String filePath =
      '$folder/$metaFilename'; // Replace with your desired file path

  File file = File(filePath);
  await file.writeAsString("Downloaded at\n", mode: FileMode.writeOnly);

  await file.writeAsString(formattedDate, mode: FileMode.writeOnlyAppend);

  print('Current date has been written to the $filePath: $formattedDate');
}

/// Download a file from a given [link].
/// After downloading it, it is saved in [name] file.
Future download(String link, String name) {
  return (HttpClient()
      .getUrl(Uri.parse(link))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) =>
          response.pipe(File(name).openWrite())));
}

/// Checks if a folder contains only the provided files.
///
/// Returns `true` if the folder contains only the provided files, otherwise `false`.
bool checkFolderForOnlyFiles(String folderPath, List<String> files) {
  Directory directory = Directory(folderPath);
  List<String> folderFiles = directory
      .listSync()
      .whereType<File>()
      .map((entity) => entity.path.split('/').last)
      .toList();

  // Check if the number of files in the folder matches the expected number
  if (folderFiles.length != files.length) {
    return false;
  }

  // Check if each file in the folder is in the provided list
  for (final file in folderFiles) {
    if (!files.contains(file)) {
      return false;
    }
  }

  return true;
}

/// Clears every file from provided [folderPath].
void clearFolder(String folderPath) {
  Directory directory = Directory(folderPath);

  List<FileSystemEntity> files = directory.listSync();

  for (FileSystemEntity file in files) {
    if (file is File) {
      file.deleteSync();
    }
  }
}

/// Creates a directory in [path] if it doesn't exist.
void createFolderIfNotExists(String path) {
  var directory = Directory(path);

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    print('Folder created: $path');
  } else {
    print('Folder already exists: $path');
  }
}

Future generateCode({
  required String path,
}) async {
  Map<String, GlyphName> glyphNames = {};
  Map<String, List<String>> classes = {};
  Map<String, GlyphRange> glyphRange = {};

  for (var metadata in Metadata.values) {
    final content = File(metadata.filePath).readAsStringSync();
    final Map<String, dynamic> json = jsonDecode(content);

    switch (metadata) {
      case Metadata.glyphNames:
        glyphNames.addEntries(
          json.entries.map(
            (e) => MapEntry(e.key, GlyphName.fromJson(e.key, e.value)),
          ),
        );
        break;
      case Metadata.classes:
        json.forEach((key, value) {
          classes[key] = List<String>.from(value);
        });
      case Metadata.range:
        glyphRange.addEntries(
          json.entries.map(
            (e) => MapEntry(e.key, GlyphRange.fromJson(e.key, e.value)),
          ),
        );
        break;
    }
  }

  var smuflCodeGenerator = SmuflCodeGenerator(
    glyphName: glyphNames,
    classes: classes,
    glyphRange: glyphRange,
  );

  Map<String, String> codes = await smuflCodeGenerator.generateCode();

  createFolderIfNotExists(path);
  createFolderIfNotExists("$path/classes");
  clearFolder("$path/classes");

  for (var code in codes.entries) {
    final outputFilePath = '$path/${code.key}.dart';

    File(outputFilePath).writeAsStringSync(code.value);

    print('Class was generated successfully at:$outputFilePath');

    formatDartCodeSync(outputFilePath);
  }
}

void formatDartCodeSync(String path) {
  final result = Process.runSync('dart', ['format', path]);

  final stdout = result.stdout;
  final stderr = result.stderr;

  print('Standard output:\n$stdout');
  print('');

  if (result.exitCode != 0) {
    throw Exception(
      'Exit code: ${result.exitCode}.\nFailed to format Dart code:\n$stderr',
    );
  }
}

main(List<String> arguments) async {
  // Check if the folder contains all the required files
  bool hasAllFiles = checkFolderForOnlyFiles(
    Metadata.localFolder,
    [...Metadata.values.map((e) => e.fileName), metaFilename],
  );

  if (arguments.contains("force-read") || !hasAllFiles) {
    print("Clearing existing files");

    clearFolder(Metadata.localFolder);

    print('Downloading latest SMuFL metadata');

    for (var metadata in Metadata.values) {
      print('${metadata.index} of ${Metadata.values.length}');
      print('Downloading: ${metadata.fileName}');
      await download(
        metadata.downloadLink,
        metadata.filePath,
      );
    }

    await recordDate(Metadata.localFolder);
  }

  await generateCode(path: '../lib/src/smufl');

  exit(0);
}
