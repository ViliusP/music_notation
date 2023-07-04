// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:async';

import 'package:cli/xsd_to_dart.dart';
import 'package:xml/xml.dart';

const metadataFiles = [
  "ranges.json",
  "glyphnames.json",
  "classes.json",
];

const repo = "https://raw.githubusercontent.com/w3c/smufl/gh-pages/metadata/";
const metaFilename = "meta.txt";

Future recordDate(String folder) async {
  String formattedDate = DateTime.now().toIso8601String();

  String filePath =
      '$folder/$metaFilename'; // Replace with your desired file path

  File file = File(filePath);
  await file.writeAsString("Downloaded at\n", mode: FileMode.writeOnly);

  await file.writeAsString(formattedDate, mode: FileMode.writeOnlyAppend);

  print('Current date has been written to the $filePath: $formattedDate');
}

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
///
/// Returns nothing.
void clearFolder(String folderPath) {
  Directory directory = Directory(folderPath);

  List<FileSystemEntity> files = directory.listSync();

  for (FileSystemEntity file in files) {
    if (file is File) {
      file.deleteSync();
    }
  }
}

void createFolderIfNotExists(String folderPath) {
  var directory = Directory(folderPath);

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    print('Folder created: $folderPath');
  } else {
    print('Folder already exists: $folderPath');
  }
}

Future generateCode({
  required String destination,
  required String filePath,
}) async {
  final content = File(filePath).readAsStringSync();

  final document = XmlDocument.parse(content);

  XsdToDart generator = XsdToDart(document: document);

  final codes = await generator.generateCode();

  final folders = codes.keys.map((k) => k.split("/").first).toSet();

  for (var folder in folders) {
    final String path = "$destination/$folder";
    createFolderIfNotExists(path);
  }

  for (var codeEntry in codes.entries) {
    final outputFilePath = '$destination/${codeEntry.key}.dart';

    File(outputFilePath).writeAsStringSync(codeEntry.value);

    print('Class was generated successfully at:$outputFilePath');
  }
}

main(List<String> arguments) async {
  const schemaFolder = '../tools/metadata';

  // Check if the folder contains all the required files
  bool hasAllFiles = checkFolderForOnlyFiles(
    schemaFolder,
    [...metadataFiles, metaFilename],
  );

  if (arguments.contains("force-read") || !hasAllFiles) {
    print("Clearing existing files");

    clearFolder(schemaFolder);

    print('Downloading latest SMuFL metadata');

    for (var file in metadataFiles) {
      print('${metadataFiles.indexOf(file)} of ${metadataFiles.length}');
      print('Downloading: $file');
      await download(repo + file, '$schemaFolder/$file');
    }

    await recordDate(schemaFolder);
  }

  // await generateCode(
  //   destination: '../lib/models',
  //   filePath: "$schemaFolder/musicxml.xsd",
  // );

  exit(0);
}
