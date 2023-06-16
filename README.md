# MusicXML Parser and Notation Renderer for Flutter

This library provides a parser for MusicXML files, and a custom renderer to display the parsed music notation in Flutter apps.

## Before using

Before you can use this library, you need to ensure you have the following software installed on your system:

1. Dart: This library is written in Dart, so you need to have the Dart SDK installed. You can download it from [the Dart website](https://dart.dev/get-dart).

2. Flutter: Since this library includes a Flutter widget for rendering music notation, you need to have Flutter installed as well. You can download it from [the Flutter website](https://flutter.dev/docs/get-started/install).

### Familiarity with MusicXML

This library is designed for parsing and rendering MusicXML files. It assumes that you are familiar with the MusicXML format and how to use it to represent musical scores. If you're not already familiar with MusicXML, you may want to review the [MusicXML documentation](https://www.musicxml.com/for-developers/) before using this library.

### Understanding of Flutter

The renderer included in this library is a Flutter widget. Therefore, a basic understanding of how to use Flutter and how to build UIs with Flutter widgets is necessary. If you're new to Flutter, the [Flutter documentation](https://flutter.dev/docs) provides a wealth of resources to help you get started.

### SMuFL Standard

Our library uses the SMuFL (Standard Music Font Layout) standard for music symbols in the rendered output. For precise rendering, you should have a SMuFL compliant font installed in your system. A list of such fonts can be found [here](https://www.smufl.org/fonts/).



## Installation

To install the library, add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  your_musicxml_library: ^0.1.0
```

Then run `flutter pub get`.

## Usage

First, import the library:

```dart
import 'package:your_musicxml_library/your_musicxml_library.dart';
```

You can then use the MusicXmlParser class to parse MusicXML data:

```dart
var parser = MusicXmlParser();
ScorePartwise score = parser.parse(xmlString);
```

To display the parsed music notation, you can use the MusicNotation widget:

```dart
MusicNotation(score: score)
```

## Contributing

Contributions are welcome! Please open an issue if you encounter any problems, or a pull request if you have improvements to suggest.

## License

This project is licensed under the MIT License.