extension ListExtensions<T> on List<T> {
  /// Returns a new list containing every nth element from the original list.
  ///
  /// This method iterates over the list and picks every nth element, starting
  /// from the first element at index 0. If n is greater than the list length, it
  /// will return a list with only the first element (if available).
  ///
  /// Parameters:
  /// - [n] - The interval to select elements. Must be greater than 0.
  ///
  /// Returns:
  /// A new list containing every nth element from the original list.
  ///
  /// Throws:
  /// - `ArgumentError` if [n] is less than or equal to 0.
  List<T> everyNth(int n) {
    if (n <= 0) {
      throw ArgumentError("n must be greater than 0", "n");
    }
    if (n == 1) return this;
    return [for (var i = 0; i < length; i += n) this[i]];
  }
}
