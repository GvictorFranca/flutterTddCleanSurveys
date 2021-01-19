import 'package:faker/faker.dart';
import 'package:flutterClean/presentation/dependencies/validation.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class MinLenghtValidation implements FieldValidation {
  final String field;
  final int size;

  MinLenghtValidation({@required this.field, @required this.size});

  ValidationError validate(String value) {
    return value?.length == size ? null : ValidationError.invalidField;
  }
}

void main() {
  MinLenghtValidation sut;

  setUp(() {
    sut = MinLenghtValidation(field: 'any_field', size: 5);
  });

  group('Error if value is empty or null', () {
    test('Should return error if value is empity', () {
      expect(sut.validate(''), ValidationError.invalidField);
    });

    test('Should return error if value is null', () {
      expect(sut.validate(null), ValidationError.invalidField);
    });
  });

  group('Test Size', () {
    test('Should return error if value is less than min size', () {
      expect(sut.validate(faker.randomGenerator.string(4, min: 1)),
          ValidationError.invalidField);
    });

    test('Should return null if value is equal than min size', () {
      expect(sut.validate(faker.randomGenerator.string(5, min: 5)), null);
    });
  });
}