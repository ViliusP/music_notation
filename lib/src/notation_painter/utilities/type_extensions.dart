extension TypeExtensions<T> on T {
  /// Attempts to cast the current object to the specified type [R].
  ///
  /// This method checks if the object (`this`) is of type [R]. If it is,
  /// it returns the object as [R]; otherwise, it returns `null`.
  /// This allows for safe casting without risking a runtime exception.
  ///
  /// Based on a suggestion from the Dart language discussion:
  /// https://github.com/dart-lang/language/issues/399#issuecomment-1109425743
  ///
  /// ### Usage Example:
  /// ```dart
  /// Object obj = "Hello, World!";
  /// String? str = obj.tryAs<String>(); // str is "Hello, World!"
  /// int? num = obj.tryAs<int>(); // num is null, as obj is not an int
  /// ```
  ///
  /// ### Returns:
  /// - The object cast to [R] if it is of that type.
  /// - `null` if the object is not of type [R].
  R? tryAs<R>() {
    var self = this;
    return self is R ? self : null;
  }
}
