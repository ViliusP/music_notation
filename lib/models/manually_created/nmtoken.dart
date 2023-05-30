class Nmtoken {
  /// Checks if provided [value] is valid NMTOKEN.
  ///
  /// Return true if valid.
  /// Otherwise - false.
  static bool validate(String value) {
    if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_\-.]*$').hasMatch(value)) {
      return false;
    }
    return true;
  }
}
