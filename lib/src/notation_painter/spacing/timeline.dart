import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:music_notation/src/notation_painter/clef_element.dart';
import 'package:music_notation/src/notation_painter/notes/chord_element.dart';
import 'package:music_notation/src/notation_painter/cursor_element.dart';
import 'package:music_notation/src/notation_painter/key_element.dart';
import 'package:music_notation/src/notation_painter/measure/measure_element.dart';
import 'package:music_notation/src/notation_painter/notes/note_element.dart';
import 'package:music_notation/src/notation_painter/notes/rest_element.dart';
import 'package:music_notation/src/notation_painter/time_beat_element.dart';

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
/// List<double> spacings = timeline.toList(10.0);
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
      switch (child) {
        case NoteElement _:
          String voice = child.note.editorialVoice.voice ?? "1";
          _value[cursor]!.add(_TimelineValue(
            index,
            child.duration,
            voice: voice,
            widgetType: NoteElement,
            name:
                child.position.toString().replaceFirst("ElementPosition  ", ""),
          ));
          cursor += child.duration.toInt();
          break;
        case RestElement rest:
          String voice = rest.note.editorialVoice.voice ?? "1";
          _value[cursor]!.add(_TimelineValue(
            index,
            child.duration,
            voice: voice,
            widgetType: RestElement,
            name:
                child.position.toString().replaceFirst("ElementPosition  ", ""),
          ));
          cursor += child.duration.toInt();
          break;
        case Chord _:
          String voice = child.notes.firstOrNull?.editorialVoice.voice ?? "1";
          _value[cursor]!.add(_TimelineValue(
            index,
            child.duration,
            voice: voice,
            widgetType: Chord,
            name:
                "C${child.position.toString().replaceFirst("ElementPosition  ", "")}",
          ));
          cursor += child.duration.toInt();
          break;
        case CursorElement cursorElement:
          _value[cursor]!.add(
            _TimelineValue(
              index,
              cursorElement.duration,
              voice: cursorElement.duration > 0 ? "F" : "B",
              name: cursorElement.duration > 0
                  ? "${cursorElement.duration.toInt()}>"
                  : "<${cursorElement.duration.toInt().abs()}",
              widgetType: CursorElement,
            ),
          );
          cursor += child.duration.toInt();
          cursor = cursor.clamp(0, double.maxFinite).toInt();
          break;
        case TimeBeatElement timeBeatElement:
          _value[cursor]!.add(
            _TimelineValue(
              index,
              0,
              offsetAfter: timeBeatElement.size.width + 16,
              voice: "-1", // The "-1" indicates attributes sector
              name: "TB",
              widgetType: TimeBeatElement,
            ),
          );
          break;
        case ClefElement clefElement:
          _value[cursor]!.add(
            _TimelineValue(
              index,
              0,
              offsetAfter: clefElement.size.width + 12,
              voice: "-1", // The "-1" indicates attributes sector
              name: "CLF",
              widgetType: ClefElement,
            ),
          );
          break;
        case KeySignatureElement keyElement:
          _value[cursor]!.add(
            _TimelineValue(
              index,
              0,
              offsetAfter: keyElement.size.width + 12,
              voice: "-1", // The "-1" indicates attributes sector
              name: "KeS",
              widgetType: KeySignatureElement,
            ),
          );
          break;
        default:
          _value[cursor]!.add(
            _TimelineValue(
              index,
              0,
              voice: "-1", // The "-1" indicates attributes sector
              name: child.runtimeType.toString().substring(0, 2),
            ),
          );
      }
      maxCursor = max(maxCursor, cursor);
    }
  }

  /// Converts the timeline into a list of time-based spatial values.
  ///
  /// This method translates the internal timeline data into a list of double
  /// values representing the spatial distribution of musical elements. Each value
  /// corresponds to a specific position on the timeline, calculated based on the
  /// provided [spacePerFullDivision], which defines the spatial representation of each
  /// time unit (e.g., pixels per beat).
  ///
  /// ### Parameters:
  /// - [spacePerFullDivision]: The spatial representation of each time unit, used for rendering.
  ///
  /// ### Returns:
  /// A list of double values representing the timeline's spatial distribution.
  ///
  /// ### Example:
  /// ```dart
  /// Timeline timeline = Timeline(divisions: 4.0);
  /// // Assume timeline.compute(...) has been called to populate _value
  /// List<double> spacings = timeline.toList(10.0);
  /// // spacings now contains spatial positions for each _TimelineValue
  /// ```
  List<double> toList(double spacePerFullDivision) {
    double spacePerBeat = spacePerFullDivision / divisions;
    int totalLength = _value.values.fold(0, (sum, list) => sum + list.length);
    List<double> spacings = List.generate(totalLength, (_) => 0);
    double offsetForNotes = (divisions / 8) * spacePerBeat;
    double biggestOffset = 0;
    _TimelineValue? biggestOffsetElement;
    // List<String> names = List.generate(totalLength, (_) => "");
    for (var entry in _value.entries) {
      List<_TimelineValue> beatCol = entry.value.sorted(
        (a, b) => a.voice.compareTo(b.voice),
      );

      int beat = entry.key;

      for (_TimelineValue val in beatCol) {
        // names[val.index] = val.name;
        if (val.duration != 0) {
          double leftOffset = offsetForNotes + (beat * spacePerBeat);
          spacings[val.index] = leftOffset;
        }
        if (val.duration == 0) {
          spacings[val.index] = offsetForNotes;
          offsetForNotes += val.offsetAfter;
        }
        if (biggestOffset < spacings[val.index]) {
          biggestOffset = spacings[val.index];
          biggestOffsetElement = val;
        }
      }
    }
    // Last item processing:
    // If there is no empty last item like backup or forward. It should have last
    // additional spacing which indicates how much space should be after last element.
    if ([
      NoteElement,
      Chord,
      RestElement,
    ].contains(biggestOffsetElement?.widgetType)) {
      spacings
          .add(biggestOffset + (biggestOffsetElement!.duration * spacePerBeat));
    }
    // print(names);
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
      int labelPad = 8;
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
      int elementCount = 0;
      for (final i in times) {
        List<_TimelineValue> values = _value[i] ?? [];
        for (var voice in _uniqueVoices) {
          String voiceOutput = voicesOutputRow[voice]!;
          final voiceElements = values.where((x) => x.voice == voice);
          elementCount += voiceElements.length;
          String cell = voiceElements.firstOrNull?.name ?? "";
          if (voiceElements.length > 1) cell = "MP${voiceElements.length}";
          voiceOutput += "${_centerPad((cell).toString(), 3)}|";
          voicesOutputRow[voice] = voiceOutput;
        }
      }

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
class _TimelineValue {
  final String voice;
  final String name;
  final int index;
  final double duration;
  final double offsetAfter;

  /// The runtime type of the [MeasureWidget] this timeline value represents.
  ///
  /// This property captures the specific class type (e.g., [NoteElement], [Chord], [CursorElement])
  /// of the associated [MeasureWidget], enabling type-specific processing or rendering.
  final Type? widgetType;

  _TimelineValue(
    this.index,
    this.duration, {
    required this.name,
    this.offsetAfter = 0,
    this.widgetType,
    required this.voice,
  });
}
