/// A kind-value indicates the type of chord. Degree elements can then add,
/// subtract, or alter from these starting points. Values
/// include:

Triads:
	major (major third, perfect fifth)
	minor (minor third,
/// perfect fifth)
	augmented (major third, augmented fifth)
	diminished (minor
/// third, diminished fifth)
Sevenths:
	dominant (major triad, minor
/// seventh)
	major-seventh (major triad, major seventh)
	minor-seventh (minor
/// triad, minor seventh)
	diminished-seventh (diminished triad, diminished
/// seventh)
	augmented-seventh (augmented triad, minor seventh)
	half-diminished
/// (diminished triad, minor seventh)
	major-minor (minor triad, major
/// seventh)
Sixths:
	major-sixth (major triad, added sixth)
	minor-sixth (minor
/// triad, added sixth)
Ninths:
	dominant-ninth (dominant-seventh, major
/// ninth)
	major-ninth (major-seventh, major ninth)
	minor-ninth (minor-seventh,
/// major ninth)
11ths (usually as the basis for alteration):
	dominant-11th
/// (dominant-ninth, perfect 11th)
	major-11th (major-ninth, perfect
/// 11th)
	minor-11th (minor-ninth, perfect 11th)
13ths (usually as the basis for
/// alteration):
	dominant-13th (dominant-11th, major 13th)
	major-13th
/// (major-11th, major 13th)
	minor-13th (minor-11th, major
/// 13th)
Suspended:
	suspended-second (major second, perfect
/// fifth)
	suspended-fourth (perfect fourth, perfect fifth)
Functional
/// sixths:
	Neapolitan
	Italian
	French
	German
Other:
	pedal (pedal-point
/// bass)
	power (perfect fifth)
	Tristan

The "other" kind is used when the
/// harmony is entirely composed of add elements.

The "none" kind is used to
/// explicitly encode absence of chords or functional harmony. In this case, the
/// root, numeral, or function element has no meaning. When using the root or
/// numeral element, the root-step or numeral-step text attribute should be set to
/// the empty string to keep the root or numeral from being displayed.
class KindValue {
  String _value;

  String get value => _value;

  set value(String value) {
    // add any necessary validation here
    _value = value;
  }

  KindValue(this._value);

}