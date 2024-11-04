const String dKeySignature = """
# Example: Rendering Adjacent Notes

This example demonstrates how the music notation rendering library handles adjacent notes within chords, covering two-note chords, stemless notes, and double stems.

It only includes chords without dotted notes, without chromatic alterations (such as sharps, flats, naturals, and others), and without multiple voices.

## Rules:

### Even Number of Adjacent Notes
For an even number of adjacent notes forming consecutive seconds, noteheads alternate positions in a “zig-zag” pattern. The lowest note always appears on the left-hand side of the stem.

### Odd Number of Adjacent Notes
For an odd number of adjacent notes forming consecutive seconds, if the stem is downward, the lowest note appears on the right-hand side of the stem. If the stem is upward, notes are arranged following the rule for an even number of adjacent notes.

### Stemless Notes
Stemless noteheads follow the same arrangement rules as stemmed notes, with offsets and alignment applied as if stems were present.
""";
