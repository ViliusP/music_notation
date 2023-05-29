// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:async';

const schemaFiles = [
  "timepart.xsl",
  "xml.xsd",
  "xlink.xsd",
  "to31.xsl",
  "sounds.dtd",
  "to11.xsl",
  "to20.xsl",
  "to10.xsl",
  "timewise.dtd",
  "score.mod",
  "to30.xsl",
  "sounds.xml",
  "sounds.xsd",
  "direction.mod",
  "musicxml.xsd",
  "opus.xsd",
  "partwise.dtd",
  "catalog.xml",
  "barline.mod",
  "container.dtd",
  "container.xsd",
  "parttime.xsl",
  "note.mod",
  "link.mod",
  "midixml.dtd",
  "common.mod",
  "midixml.xsl",
  "opus.dtd",
  "layout.mod",
  "isolat1.ent",
  "attributes.mod",
  "identity.mod",
  "isolat2.ent",
];

const repo = "https://raw.githubusercontent.com/w3c/musicxml/gh-pages/schema/";

Future recordDate() async {
  DateTime now = DateTime.now();
  String formattedDate = '${now.year}-${now.month}-${now.day}';

  String filePath =
      './tools/raw_schemas/meta.txt'; // Replace with your desired file path

  File file = File(filePath);
  await file.writeAsString(formattedDate);

  print('Current date has been written to the $filePath: $formattedDate');
}

Future download(String link, String name) {
  return (HttpClient()
      .getUrl(Uri.parse(link))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) =>
          response.pipe(File(name).openWrite())));
}

main() async {
  print('Downloading latest MusicXML specifications');
  for (var file in schemaFiles) {
    print('${schemaFiles.indexOf(file)} of ${schemaFiles.length}');
    print('Downloading: $file');
    await download(repo + file, './tools/raw_schemas/$file');
  }

  recordDate();

  // print('generating');
  // await generateCode(
  //   template: './tool/material_design_icons_flutter.dart.template',
  //   dest: './lib/material_design_icons_flutter.dart',
  //   info: info,
  // );
  // await generateCode(
  //   template: './tool/icon_map.dart.template',
  //   dest: './lib/icon_map.dart',
  //   info: info,
  // );
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
