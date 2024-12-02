# MusicXML Parser and Notation Renderer for Flutter

!!! UNDER CONSTRUCTION !!!

This library provides a parser for MusicXML files, and a custom renderer to display the parsed music notation in Flutter apps.

## Before using

Before you can use this library, you need to ensure you have the following software installed on your system:

1. Dart: This library is written in Dart, so you need to have the Dart SDK installed. You can download it from [the Dart website](https://dart.dev/get-dart).

2. Flutter: Since this library includes a Flutter widget for rendering music notation, you need to have Flutter installed as well. You can download it from [the Flutter website](https://flutter.dev/docs/get-started/install).

### Understanding of Flutter

A basic understanding of how to use Flutter and how to build UIs with Flutter widgets is necessary. If you're new to Flutter, the [Flutter documentation](https://flutter.dev/docs) provides resources to help you get started.

### Familiarity with MusicXML

This library is designed for parsing and rendering MusicXML files. It assumes that you are familiar with the MusicXML format and how to use it to represent musical scores. If you're not already familiar with MusicXML, you may want to review the [MusicXML documentation](https://www.musicxml.com/for-developers/) before using this library.

### SMuFL Standard

Our library uses the SMuFL (Standard Music Font Layout) standard for music symbols in the rendered output. More info and a list of popular fonts can be found [here](https://www.smufl.org/fonts/).

### Music notation rules

This library follows standard music notation practices based on Elaine Gould's book Behind Bars, a widely used guide for music engraving rules.

### Current status

|<img src='./docs/images/current_status_apres.png' width='550'>|
|:--:|
| *Current rendering of Gabriel Fauré "Après un rêve"* |

|<img src='./docs/images/target_apres.png' width='550'>|
|:--:|
| *Target rendering of Gabriel Fauré "Après un rêve"* |

**IMPORTANT NOTE:** This library is currently in its early stages of development and not ready for production use. The API is still under active development and can change frequently. We strongly advise not using this library in a production environment as breaking changes may occur.

This library is currently in a **preview phase** and we welcome all developers who are interested in contributing and helping us shape the future of this library.

## Installation

To install the library, add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  music_ntation: ^0.0.1
```

Then run `flutter pub get`.

## Usage

```dart
// The API is still under development. Please refer to the `example` folder for usage details.
```

## Future

This library is still evolving and has some limitations. While it may not meet every use case yet, we are actively working on improvements. Here are some features and enhancements we’re considering (though not guaranteed):

- Support for additional XML validation rules and constraints (e.g. 'token' type validation);
- Enhanced error handling and error reporting;
- Improved documentation and examples;
- Simple classes remake with upcoming [extension types](https://github.com/dart-lang/language/issues/2727);
- Support for more advanced and niche rendering rules.

## Contributing

Contributions and feedback are always welcome. If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request. However, please understand that the development and maintenance of this package depend on the availability and interests of the contributors.

*Just keep in mind that we're not here to cater to your every desire. We might pretend to care and even consider your suggestions.*

## License

This project is licensed under the MIT License.
