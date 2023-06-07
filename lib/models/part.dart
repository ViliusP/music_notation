import 'package:music_notation/models/elements/music_data/music_data.dart';
import 'package:xml/xml.dart';

class Part {
  final List<Measure> measures;
  final PartAttributes partAttributes;

  Part({
    required this.measures,
    required this.partAttributes,
  });

  factory Part.fromXml(XmlElement xmlElement) {
    return Part(
      measures: xmlElement
          .findElements('measure')
          .map((element) => Measure.fromXml(element))
          .toList(),
      partAttributes: PartAttributes.fromXml(xmlElement),
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('part', nest: () {
      for (var measure in measures) {
        builder.element(measure.toXml());
      }
      builder.attribute('part-attributes', partAttributes.toXml());
    });
    return builder.buildDocument().rootElement;
  }
}

class Measure {
  final MusicData data;
  final MeasureAttributes measureAttributes;

  Measure({
    required this.data,
    required this.measureAttributes,
    required musicData,
  });

  factory Measure.fromXml(XmlElement xmlElement) {
    return Measure(
      musicData: data.fromXml(xmlElement.getElement('music-data')),
      measureAttributes: MeasureAttributes.fromXml(xmlElement),
    );
  }

  XmlElement toXml() {
    final builder = XmlBuilder();
    builder.element('measure', nest: data.toXml());
    builder.attribute('measure-attributes', measureAttributes.toXml());
    return builder.buildDocument().rootElement;
  }
}
