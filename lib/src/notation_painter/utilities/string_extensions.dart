extension FormattingExtension on String {
  /// Centers the string by adding spaces to the left and right.
  ///
  /// - If [width] is less than or equal to the string's length, returns the original string.
  /// - Pads evenly when possible, adding any extra space to the right when padding is uneven.
  /// - Handles cases where [width] is negative by returning the original string.
  String padCenter(int width) {
    // Return the original string if the specified width is less than or equal to the string's length.
    if (width <= length) {
      return this;
    }

    // Calculate the total padding needed.
    int totalPadding = width - length;

    // Calculate the left padding; any remainder will go to the right padding.
    int leftPadding = totalPadding ~/ 2;

    // Add left and right padding to the string.
    return padLeft(length + leftPadding).padRight(width);
  }
}
