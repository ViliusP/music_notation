import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/measure_element.dart';
import 'package:music_notation/src/notation_painter/note_element.dart';

/// Represents a timeline for musical elements within a score.
///
/// The [Timeline] class processes a list of [MeasureWidget] instances, categorizing
/// them based on their position in time and associating them with specific voices.
/// This is particularly useful for rendering musical notation, analyzing score structure,
/// or synchronizing musical events with other media.
///
/// ### Example:
/// ```dart
/// Timeline timeline = Timeline(divisions: 4.0);
/// timeline.compute(measureWidgets);
/// print(timeline);
/// ```
class Timeline {
  /// The number of divisions per measure.
  ///
  /// This value typically corresponds to the musical notation's time signature,
  /// indicating how many subdivisions exist within each measure.
  final double divisions;

  /// Internal storage mapping time positions to their respective timeline values.
  ///
  /// The key represents the cursor's position in time (e.g., beats or subdivisions),
  /// and the value is a list of [_TimelineValue] instances that occur at that position.
  final Map<int, List<_TimelineValue>> _value = {};

  /// Tracks the furthest point in time reached by the timeline.
  ///
  /// This is useful for determining the overall length of the timeline and for
  /// generating visual representations or performing analyses.
  int maxCursor = 0;

  /// A set of unique voice identifiers present in the timeline.
  ///
  /// Voices represent different musical lines or parts within a score.
  /// This getter extracts all unique voices from the internal [_value] map,
  /// ensuring that each voice is only listed once.
  Set<String> get _uniqueVoices => _value.values
      .expand((list) => list) // Flatten all lists into a single iterable
      .map((timelineValue) => timelineValue.voice) // Extract the voice property
      .whereType<String>() // Filter out null values and cast to String
      .toSet(); // Convert to a set to remove duplicates

  /// Creates a [Timeline] instance with the specified number of divisions.
  ///
  /// ### Parameters:
  /// - [divisions]: The number of divisions per measure, typically based on the time signature.
  Timeline({required this.divisions});

  /// Processes a list of [MeasureWidget] instances to populate the timeline.
  ///
  /// This method iterates through each [MeasureWidget], categorizing them based
  /// on their type (e.g., [NoteElement], [Chord], [CursorElement]) and associating
  /// them with the appropriate time positions and voices. It updates the internal
  /// [_value] map and tracks the maximum cursor position.
  ///
  /// ### Parameters:
  /// - [children]: A list of [MeasureWidget] instances representing musical elements.
  void compute(List<MeasureWidget> children) {
    int cursor = 0;
    for (final (index, child) in children.indexed) {
      _value[cursor] ??= [];
      _value[cursor] = [];
      switch (child) {
        case NoteElement _:
          String voice = child.note.editorialVoice.voice ?? "1";
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
          _value[cursor]!.add(
            _TimelineValue(
              index,
              child.duration,
              voice: child.duration > 0 ? "F" : "B",
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

  /// Converts the timeline into a list of time-based values.
  ///
  /// ### Parameters:
  /// - [spacePerTimeUnit]: The spatial representation of each time unit, used for rendering.
  ///
  /// ### Returns:
  /// A list of double values representing the timeline's spatial distribution.
  Map<int, double> toList(double spacePerTimeUnit) {
    Map<int, double> spacings = {};
    return spacings;
  }

  /// Generates a string representation of the timeline for debugging purposes.
  ///
  /// When in debug mode (`kDebugMode` is `true`) and the timeline has recorded values,
  /// this method constructs a formatted string that visualizes the timeline's structure,
  /// including time labels and voice-specific elements.
  ///
  /// ### Returns:
  /// A string representation of the timeline if in debug mode; otherwise, the default `toString` implementation.
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
        for (var voice in _uniqueVoices.sorted())
          voice: "| ${'Voice $voice'.padRight(labelPad)} ||"
      };

      for (final i in times) {
        List<_TimelineValue> values = _value[i] ?? [];
        for (var voice in _uniqueVoices) {
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
