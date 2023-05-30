// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:async';

import 'package:cli/xsd_to_dart.dart';
import 'package:xml/xml.dart';

const schemaFiles = [
  "timepart.xsl",
  "xml.xsd",
  "xlink.xsd",
  "to31.xsl",
  // "sounds.dtd",
  "to11.xsl",
  "to20.xsl",
  "to10.xsl",
  // "timewise.dtd",
  // "score.mod",
  "to30.xsl",
  "sounds.xml",
  "sounds.xsd",
  // "direction.mod",
  "musicxml.xsd",
  "opus.xsd",
  // "partwise.dtd",
  "catalog.xml",
  // "barline.mod",
  // "container.dtd",
  "container.xsd",
  "parttime.xsl",
  // "note.mod",
  // "link.mod",
  // "midixml.dtd",
  // "common.mod",
  "midixml.xsl",
  // "opus.dtd",
  // "layout.mod",
  "isolat1.ent",
  // "attributes.mod",
  // "identity.mod",
  "isolat2.ent",
];

const repo = "https://raw.githubusercontent.com/w3c/musicxml/gh-pages/schema/";
const metaFilename = "meta.txt";

Future recordDate() async {
  String formattedDate = DateTime.now().toIso8601String();

  String filePath =
      './tools/raw_schemas/$metaFilename'; // Replace with your desired file path

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

Future generateCode(
    {required String destination, required String filePath}) async {
  final content = File(filePath).readAsStringSync();

  final document = XmlDocument.parse(content);

  XsdToDart generator = XsdToDart(document: document);

  final code = await generator.generateCode();

  final outputFilePath = '$destination/generated_classes.dart';
  File(outputFilePath).writeAsStringSync(code);

  print('Dart classes generated successfully at: $outputFilePath');
}

main(List<String> arguments) async {
  const schemaFolder = './tools/raw_schemas';

  // Check if the folder contains all the required files
  bool hasAllFiles =
      checkFolderForOnlyFiles(schemaFolder, [...schemaFiles, metaFilename]);

  if (arguments.contains("force-read") || !hasAllFiles) {
    print("Clearing existing files");

    clearFolder(schemaFolder);

    print('Downloading latest MusicXML specifications');

    for (var file in schemaFiles) {
      print('${schemaFiles.indexOf(file)} of ${schemaFiles.length}');
      print('Downloading: $file');
      await download(repo + file, '$schemaFolder/$file');
    }

    await recordDate();
  }

  // print('generating');
  // await generateCode(
  //   template: './tool/material_design_icons_flutter.dart.template',
  //   dest: './lib/material_design_icons_flutter.dart',
  //   info: info,
  // );
  await generateCode(
    destination: './lib/models',
    filePath: "$schemaFolder/musicxml.xsd",
  );
  // File('./tool/materialdesignicons-webfont.ttf')
  //     .renameSync('./lib/fonts/materialdesignicons-webfont.ttf');
  // File('./tool/_variables.scss').deleteSync();
  // var spec = File('./pubspec.yaml').readAsStringSync();
  // RegExpMatch? match =
  //     RegExp(r'version:\s(\d+)\.(\d+)\.(\d+)').firstMatch(spec);
  // if (match == null) {
  //   throw 'no version in spec';
  // }
  // var currentVersion = match[3];
  // var latestVersion = info.version.replaceAll('.', '');
  // print(
  //     'done, latest version: ${info.version}, need publish: ${currentVersion != latestVersion}');
  exit(0);
}
