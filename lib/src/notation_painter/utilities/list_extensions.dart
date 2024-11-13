extension ListExtensions<T> on List<T> {
  List<T> everyNth(int n) => [for (var i = 0; i < length; i += n) this[i]];
}
