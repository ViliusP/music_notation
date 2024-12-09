import 'package:collection/collection.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/attributes.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/clef.dart';
import 'package:music_notation/src/models/elements/music_data/attributes/key.dart';
import 'package:music_notation/src/models/elements/score/part.dart';
import 'package:music_notation/src/notation_painter/utilities/type_extensions.dart';

class NotationContext {
  final Clef? clef;
  final TraditionalKey? key;
  final double? divisions;

  const NotationContext({
    required this.divisions,
    required this.clef,
    required this.key,
  });

  const NotationContext.empty()
      : this(
          divisions: null,
          clef: null,
          key: null,
        );

  NotationContext copyWith({
    Clef? clef,
    double? divisions,
    TraditionalKey? key,
  }) {
    return NotationContext(
      clef: clef ?? this.clef,
      divisions: divisions ?? this.divisions,
      key: key ?? this.key,
    );
  }

  NotationContext afterMeasure({
    required int? staff,
    required Measure measure,
  }) {
    NotationContext context = copyWith();

    for (int i = 0; i < measure.data.length; i++) {
      var element = measure.data[i];
      switch (element) {
        case Attributes attributes:
          var keys = element.keys;
          Key? musicKey;
          if (keys.length == 1 && keys.first.number == null) {
            musicKey = keys.first;
          }
          if (staff != null && keys.length > 1) {
            musicKey = keys.firstWhereOrNull(
              (element) => element.number == staff,
            );
          }

          context = context.copyWith(
              divisions: attributes.divisions,
              key: musicKey.tryAs<TraditionalKey>(),
              clef: element.clefs.firstWhereOrNull(
                (element) => staff != null ? element.number == staff : true,
              ));
          break;
      }
    }
    return context;
  }
}
