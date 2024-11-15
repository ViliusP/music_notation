/// Generates all combinations of the given lists.
///
/// Each combination is represented as a list of elements, where the i-th element
/// corresponds to a value from the i-th input list.
///
/// Example:
/// ```dart
/// var result = generateCombinations([
///   [1, 2],
///   ['a', 'b'],
///   [true, false],
/// ]);
/// // Result:
/// // [
/// //   [1, 'a', true],
/// //   [1, 'a', false],
/// //   [1, 'b', true],
/// //   [1, 'b', false],
/// //   [2, 'a', true],
/// //   [2, 'a', false],
/// //   [2, 'b', true],
/// //   [2, 'b', false],
/// // ]
/// ```
List<List<T>> generateCombinations<T>(List<List<T>> lists) {
  if (lists.isEmpty) return [];
  return lists.fold<List<List<T>>>([[]], (combinations, currentList) {
    return [
      for (var combination in combinations)
        for (var item in currentList) [...combination, item]
    ];
  });
}
