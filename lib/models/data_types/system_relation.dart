enum SystemRelation {
  onlyTop,
  alsoTop,
  none;

  static SystemRelation fromString(String value) {
    throw UnimplementedError();
  }
}

enum SystemRelationNumber {
  onlyTop,
  onlyBottom,
  alsoTop,
  alsoBottom,
  none;

  static SystemRelationNumber fromString(String value) {
    throw UnimplementedError();
  }
}
