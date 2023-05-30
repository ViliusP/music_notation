import 'package:music_notation/models/manually_created/score_part.dart';

class PartList {
  ScorePart? scorePart;

  PartList({this.scorePart});
}

class Part {
  Measure? measure;

  Part({this.measure});
}

class Measure {
  int? number;
  Attributes? attributes;
  Note? note;

  Measure({
    this.number,
    this.attributes,
    this.note,
  });
}

class Attributes {
  int? divisions;
  Key? key;
  Time? time;
  Clef? clef;

  Attributes({this.divisions, this.key, this.time, this.clef});

  Attributes.fromJson(Map<String, dynamic> json) {
    divisions = json['divisions'];
    key = json['key'] != null ? Key.fromJson(json['key']) : null;
    time = json['time'] != null ? Time.fromJson(json['time']) : null;
    clef = json['clef'] != null ? Clef.fromJson(json['clef']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['divisions'] = divisions;
    if (key != null) {
      data['key'] = key!.toJson();
    }
    if (time != null) {
      data['time'] = time!.toJson();
    }
    if (clef != null) {
      data['clef'] = clef!.toJson();
    }
    return data;
  }
}

class Key {
  int? fifths;

  Key({this.fifths});

  Key.fromJson(Map<String, dynamic> json) {
    fifths = json['fifths'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fifths'] = fifths;
    return data;
  }
}

class Time {
  int? beats;
  int? beatType;

  Time({this.beats, this.beatType});

  Time.fromJson(Map<String, dynamic> json) {
    beats = json['beats'];
    beatType = json['beat-type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['beats'] = beats;
    data['beat-type'] = beatType;
    return data;
  }
}

class Clef {
  String? sign;
  int? line;

  Clef({this.sign, this.line});

  Clef.fromJson(Map<String, dynamic> json) {
    sign = json['sign'];
    line = json['line'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sign'] = sign;
    data['line'] = line;
    return data;
  }
}

class Note {
  Pitch? pitch;
  int? duration;
  String? type;

  Note({this.pitch, this.duration, this.type});

  Note.fromJson(Map<String, dynamic> json) {
    pitch = json['pitch'] != null ? Pitch.fromJson(json['pitch']) : null;
    duration = json['duration'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pitch != null) {
      data['pitch'] = pitch!.toJson();
    }
    data['duration'] = duration;
    data['type'] = type;
    return data;
  }
}

class Pitch {
  String? step;
  int? octave;

  Pitch({this.step, this.octave});

  Pitch.fromJson(Map<String, dynamic> json) {
    step = json['step'];
    octave = json['octave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['step'] = step;
    data['octave'] = octave;
    return data;
  }
}
