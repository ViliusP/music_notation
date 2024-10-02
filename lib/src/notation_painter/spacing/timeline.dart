import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/measure_element.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';

class Timeline {
  final double divisions;

  final Map<int, List<_TimelineValue>> _value = {};
  int maxCursor = 0;

  Set<String> get uniqueVoices => _value.values
      .expand((list) => list) // Flatten all lists into a single iterable
      .map((timelineValue) => timelineValue.voice) // Extract the voice property
      .whereType<String>() // Filter out null values and cast to String
      .toSet(); // Convert to a set to remove duplicates

  Timeline({required this.divisions});

  void compute(List<MeasureWidget> children) {
    int cursor = 0;
    // _value[cursor] = [];
    for (final (index, child) in children.indexed) {
      switch (child) {
        case NoteElement _:
          String voice = child.note.editorialVoice.voice ?? "1";
          if (_value[cursor] == null) {
            _value[cursor] = [];
          }
          _value[cursor]!.add(_TimelineValue(
            index,
            child.duration,
            voice: voice,
            name:
                "C${child.position.toString().replaceFirst("ElementPosition  ", "")}",
          ));
          cursor += child.duration.toInt();
          break;
        case Chord _:
          String voice = child.notes.firstOrNull?.editorialVoice.voice ?? "1";
          if (_value[cursor] == null) {
            _value[cursor] = [];
          }
          _value[cursor]!.add(_TimelineValue(
            index,
            child.duration,
            voice: voice,
            name:
                "C${child.position.toString().replaceFirst("ElementPosition  ", "")}",
          ));
          cursor += child.duration.toInt();
          break;
        case CursorElement _:
          if (_value[cursor] == null) {
            _value[cursor] = [];
          }
          _value[cursor]!.add(
            _TimelineValue(
              index,
              child.duration,
              voice: child.duration > 0 ? "8" : "9",
              name: child.duration > 0
                  ? "${child.duration.toInt()}>"
                  : "<${child.duration.toInt().abs()}",
            ),
          );
          cursor += child.duration.toInt();
          continue;
      }
      maxCursor = max(maxCursor, cursor);
    }
  }

  List<double> toList(double spacePerTimeUnit) {
    return [];
  }

  @override
  String toString() {
    if (kDebugMode && _value.keys.isNotEmpty) {
      int labelPad = 7;
      String row1 = "| ${'Time'.padRight(labelPad)} ||";

      final times = Iterable.generate(
        maxCursor + 1,
        (i) => i,
      );

      for (final i in times) {
        if (i == times.length - 1) {
          row1 += "${_centerPad('L', 3)}|";
          break;
        }
        row1 += "${_centerPad(i.toString(), 3)}|";
      }

      // Create a map with voices as keys and empty strings as values
      Map<String, String> voicesOutputRow = {
        for (var voice in uniqueVoices.sorted())
          voice: "| ${'Voice $voice'.padRight(labelPad)} ||"
      };

      for (final i in times) {
        List<_TimelineValue> values = _value[i] ?? [];
        for (var voice in uniqueVoices) {
          String voiceOutput = voicesOutputRow[voice]!;
          final voiceElements = values.where((x) => x.voice == voice);
          String cell = voiceElements.firstOrNull?.name ?? "";
          if (voiceElements.length > 1) cell = "MLP";
          voiceOutput += "${_centerPad((cell).toString(), 3)}|";
          voicesOutputRow[voice] = voiceOutput;
        }
      }

      String output = "| ${'Divisions: $divisions'.padRight(row1.length - 3)}|";
      String divider = '=' * output.length;
      output = "\n$divider\n$output\n$divider\n$row1\n$divider";

      for (final voiceOutput in voicesOutputRow.values) {
        output += '\n$voiceOutput';
      }

      output += "\n$divider";

      return output;
    }
    return super.toString();
  }

  String _centerPad(String input, int width) {
    int totalPadding = width - input.length;

    // Calculate left and right padding
    int leftPadding = totalPadding ~/ 2;

    // Pad the string
    return input.padLeft(input.length + leftPadding).padRight(width);
  }
}

class _TimelineValue {
  final String? voice;
  final String? name;
  final int index;
  final double duration;

  _TimelineValue(
    this.index,
    this.duration, {
    this.name,
    this.voice,
  });
}
