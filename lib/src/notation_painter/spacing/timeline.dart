import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:music_notation/src/notation_painter/clef_element.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/properties/layout_properties.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/notes/rhythmic_element.dart';
import 'package:music_notation/src/notation_painter/time_beat_element.dart';
import 'package:music_notation/src/notation_painter/utilities/type_extensions.dart';

part "beat_timeline.dart";
part "beat_timeline_v2.dart";

/// Represents a timeline for musical elements within a score.
///
/// The [MeasureTimeline] class processes a list of [MeasureWidget] instances, categorizing
/// them based on their position in time and associating them with specific voices.
/// This is particularly useful for rendering musical notation, analyzing score structure,
/// or synchronizing musical events with other media.
///
/// ### Example:
/// ```dart
/// Timeline timeline = Timeline(divisions: 4.0);
/// timeline.compute(measureWidgets);
/// List<double> spacings = timeline.toList(10.0);
/// print(timeline);
/// ```
class MeasureTimeline {
  /// The number of divisions per measure.
  ///
  /// This value typically corresponds to the musical notation's time signature,
  /// indicating how many subdivisions exist within each measure.
  final double divisions;

  /// Internal storage mapping time positions to their respective timeline values.
  ///
  /// The key represents the cursor's position in time (e.g., beats or subdivisions),
  /// and the value is a list of [_TimelineValue] instances that occur at that position.
  final SplayTreeMap<TimelinePosition, List<TimelineValue>> values;

  /// A set of unique voice identifiers present in the timeline.
  ///
  /// Voices represent different musical lines or parts within a score.
  /// This getter extracts all unique voices from the internal [_value] map,
  /// ensuring that each voice is only listed once.
  Set<String> get uniqueVoices => values.values
      .expand((list) => list) // Flatten all lists into a single iterable
      .map((timelineValue) => timelineValue.voice) // Extract the voice property
      .whereType<String>() // Filter out null values and cast to String
      .toSet(); // Convert to a set to remove duplicates

  /// Creates a [MeasureTimeline] instance with the specified number of divisions.
  ///
  /// ### Parameters:
  /// - [divisions]: The number of divisions per measure, typically based on the time signature.
  MeasureTimeline._(this.values, this.divisions);

  /// Processes a list of [MeasureWidget] instances to populate the timeline.
  ///
  /// This method iterates through each [MeasureWidget], categorizing them based
  /// on their type (e.g., [NoteElement], [Chord], [CursorElement]) and associating
  /// them with the appropriate time positions and voices. It updates the internal
  /// [_values] map and tracks the maximum cursor position.
  ///
  /// ### Parameters:
  /// - [children] - A list of [MeasureWidget] instances representing musical elements.
  factory MeasureTimeline.fromMeasureElements(
    List<MeasureWidget> children,
  ) {
    double divisions = 1;
    for (var child in children.reversed) {
      if (child is RhythmicElement) {
        divisions = child.notationContext.divisions!;
        break;
      }
    }

    Map<TimelinePosition, List<TimelineValue>> values = {};
    int cursor = 0;
    TimelineValue? valueToAdd;

    for (final (index, child) in children.indexed) {
      switch (child) {
        case NoteElement note:
          String voice = child.note.editorialVoice.voice ?? "1";
          valueToAdd = TimelineValue(
            index,
            child.duration,
            voice: voice,
            widgetType: RhythmicElement,
            width: note.baseSize.width,
            name: child.position.toString().replaceFirst(
                  "ElementPosition  ",
                  "",
                ),
            leftOffset: note.alignmentPosition.left!,
          );
        case RestElement rest:
          String voice = rest.note.editorialVoice.voice ?? "1";
          valueToAdd = TimelineValue(
            index,
            child.duration,
            voice: voice,
            width: rest.baseSize.width,
            widgetType: RhythmicElement,
            name: "R",
            leftOffset: rest.alignmentPosition.left!,
          );
        case Chord chord:
          String voice = child.notes.firstOrNull?.editorialVoice.voice ?? "1";
          valueToAdd = TimelineValue(
            index,
            child.duration,
            voice: voice,
            widgetType: RhythmicElement,
            width: chord.baseSize.width,
            name:
                "C${child.position.toString().replaceFirst("ElementPosition  ", "")}",
            leftOffset: chord.alignmentPosition.left!,
          );
        case CursorElement cursorElement:
          valueToAdd = TimelineValue(
            index,
            cursorElement.duration,
            voice: cursorElement.voice ?? valueToAdd?.voice ?? "?",
            name: cursorElement.duration > 0
                ? "${cursorElement.duration.toInt()}>"
                : "<${cursorElement.duration.toInt().abs()}",
            widgetType: CursorElement,
            leftOffset: cursorElement.alignmentPosition.left!,
          );

        case TimeBeatElement timeBeatElement:
          valueToAdd = TimelineValue(
            index,
            0,
            width: timeBeatElement.baseSize.width,
            voice: "-1", // The "-1" indicates attributes sector
            name: "TB",
            widgetType: TimeBeatElement,
            leftOffset: timeBeatElement.alignmentPosition.left!,
          );
        case ClefElement clefElement:
          valueToAdd = TimelineValue(
            index,
            0,
            width: clefElement.baseSize.width,
            voice: "-1", // The "-1" indicates attributes sector
            name: "CLF",
            widgetType: ClefElement,
            leftOffset: clefElement.alignmentPosition.left!,
          );
        case KeySignatureElement keyElement:
          valueToAdd = TimelineValue(
            index,
            0,
            width: keyElement.baseSize.width,
            voice: "-1", // The "-1" indicates attributes sector
            name: "KeS",
            widgetType: KeySignatureElement,
            leftOffset: keyElement.alignmentPosition.left!,
          );
        default:
          valueToAdd = TimelineValue(
            index,
            0,
            voice: "-1", // The "-1" indicates attributes sector
            name: child.runtimeType.toString().substring(0, 2),
            width: child.baseSize.width,
            leftOffset: child.alignmentPosition.left!,
          );
      }
      TimelinePosition pos;

      if (valueToAdd.widgetType == RhythmicElement) {
        pos = TimelinePosition(cursor);
      } else {
        pos = TimelinePosition(cursor, false);
      }
      values[pos] ??= [];
      values[pos]!.add(valueToAdd);

      cursor += valueToAdd.duration.toInt();
      if (valueToAdd.widgetType == CursorElement) {
        cursor = cursor.clamp(0, double.maxFinite).toInt();
      }
    }

    return MeasureTimeline._(
      SplayTreeMap.from(values),
      divisions,
    );
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
    if (kDebugMode && values.keys.isNotEmpty) {
      int labelPad = 8;
      String row1 = "| ${'Time'.padRight(labelPad)} ||";

      for (var k in values.keys) {
        row1 += "${_centerPad(k.toString(), 3)}|";
      }

      TimelinePosition lastKey = values.keys.last;

      if (lastKey.isRhytmic) {
        double lastDuration = values[lastKey]!.map((v) => v.duration).max;
        int toGenerate = lastDuration.toInt() - 1;
        if (toGenerate < 0) toGenerate = 0;

        for (var i in List.generate((toGenerate), (i) => i + 1)) {
          int cellNumber = lastKey.value + i;
          row1 += "${_centerPad((cellNumber).toString(), 3)}|";
        }
      }

      // Create a map with voices as keys and empty strings as values
      Map<String, String> voicesOutputRow = {
        for (var voice in uniqueVoices.sorted())
          voice: "| ${'Voice $voice'.padRight(labelPad)} ||"
      };
      int elementCount = 0;

      values.forEach((key, values) {
        for (var voice in uniqueVoices) {
          String voiceOutput = voicesOutputRow[voice]!;
          final voiceElements = values.where((x) => x.voice == voice);
          elementCount += voiceElements.length;
          String cell = voiceElements.firstOrNull?.name ?? "";
          if (voiceElements.length > 1) cell = "MP${voiceElements.length}";
          voiceOutput += "${_centerPad((cell).toString(), 3)}|";
          voicesOutputRow[voice] = voiceOutput;
        }
      });

      String output = 'Divisions: $divisions | Length: $elementCount';
      output = "| ${output.padRight(row1.length - 4)} |";
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

/// Represents a value within the timeline, associated with a specific time position.
///
/// The [_TimelineValue] class encapsulates information about a musical element's
/// occurrence in the timeline, including its voice, name, index within the measure,
/// duration, and any additional offset required after the element.
///
/// This class is used internally by the [Timeline] class to organize and retrieve
/// musical elements based on their temporal positioning.
///
/// ### Example:
/// ```dart
/// _TimelineValue timelineValue = _TimelineValue(
///   index: 5,
///   duration: 2.0,
///   voice: "1",
///   name: "CPosition",
///   offsetAfter: 1.0,
/// );
/// ```
class TimelineValue {
  final String voice;
  final String name;
  final int index;
  final double duration;
  final double width;
  final double leftOffset;

  /// The runtime type of the [MeasureWidget] this timeline value represents.
  ///
  /// This property captures the specific class type (e.g., [NoteElement], [Chord], [CursorElement])
  /// of the associated [MeasureWidget], enabling type-specific processing or rendering.
  final Type? widgetType;

  TimelineValue(
    this.index,
    this.duration, {
    required this.leftOffset,
    required this.name,
    this.width = 0,
    this.widgetType,
    required this.voice,
  });
}

class TimelinePosition implements Comparable<TimelinePosition> {
  final int value;
  final bool isRhytmic;

  TimelinePosition(
    this.value, [
    this.isRhytmic = true,
  ]);

  @override
  int compareTo(TimelinePosition other) {
    if (value != other.value) {
      return value.compareTo(other.value); // Compare by value first
    }
    return isRhytmic == other.isRhytmic
        ? 0
        : (isRhytmic ? 1 : -1); // `isRhytmic` as secondary comparison
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelinePosition &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          isRhytmic == other.isRhytmic;

  @override
  int get hashCode => Object.hash(value, isRhytmic);

  @override
  String toString() => "$value${!isRhytmic ? "*" : ""}";
}
