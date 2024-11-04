import 'package:flutter/foundation.dart';
import 'package:music_notation/src/models/elements/music_data/note/note.dart';
import 'package:music_notation/src/models/elements/music_data/note/stem.dart';

/// Set of static methods to help calculating direction of stems
class Stemming {
}

enum StemDirection {
  up,
  down;

  static StemDirection? fromStemValue(StemValue value) {
    switch (value) {
      case StemValue.double:
        if (kDebugMode) {
          print("Currently `StemValue.double` is not supported yet");
        }
        return up;
      case StemValue.none:
        return null;
      case StemValue.up:
        return up;
      case StemValue.down:
        return down;
    }
  }
}
