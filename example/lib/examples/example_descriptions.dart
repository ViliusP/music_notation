const String dKeySignature = """
# Example: Rendering Adjacent Notes

This example illustrates how the music notation rendering library handles
adjacent notes within chords: two notes, stemless notes, and double stems.

# Rules:

### Two Adjacent Notes
- When two adjacent notes are separated by an interval of a second, the noteheads are staggered, with the higher note positioned slightly to the right.
- Ledger lines align across both notes, regardless of their staggered horizontal offset.

### More Than Two Adjacent Notes
- For three adjacent notes forming seconds, the middle note is placed to the left, while the highest and lowest notes are slightly offset to the right.
- When four adjacent notes form consecutive seconds, the notes alternate positions in a “zig-zag” pattern to ensure each notehead is visible.
- Ledger lines align across all notes, maintaining uniform spacing.

### Stemless Notes
- Stemless noteheads are arranged as if they were stemmed: aligned vertically with consistent spacing, as in a standard chord.
- Accidentals and ledger lines are positioned without additional offsets for compactness.

### Double Stems (Polyphonic Notation)
- Chords with double stems display notes on the “correct” side of each stem, aligning vertically within each voice.
- Stems are extended to the appropriate lengths for each voice without overlap.
""";
