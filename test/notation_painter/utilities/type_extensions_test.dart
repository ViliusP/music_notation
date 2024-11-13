import 'package:music_notation/src/notation_painter/utilities/type_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('TypeExtensions.tryAs', () {
    test('Successful casting to the same type', () {
      Object obj = "Hello, World!";
      String? result = obj.tryAs<String>();
      expect(result, equals("Hello, World!"));
    });

    test('Unsuccessful casting to an incompatible type', () {
      Object obj = "Hello, World!";
      int? result = obj.tryAs<int>();
      expect(result, isNull);
    });

    test('Casting from int to num (supertype)', () {
      int obj = 42;
      num? result = obj.tryAs<num>();
      expect(result, equals(42));
    });

    test('Casting from num to int (subtype)', () {
      num obj = 42;
      int? result = obj.tryAs<int>();
      expect(result, equals(42));
    });

    test('Casting null value', () {
      // ignore: avoid_init_to_null
      Object? obj = null;
      String? result = obj.tryAs<String>();
      expect(result, isNull);
    });

    test('Casting to dynamic type', () {
      String obj = "Test";
      dynamic result = obj.tryAs<dynamic>();
      expect(result, equals("Test"));
    });

    test('Casting object to itself', () {
      Object obj = "Self";
      Object? result = obj.tryAs<Object>();
      expect(result, equals("Self"));
    });
  });
}
