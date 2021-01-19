import 'package:faker/faker.dart';
import 'package:flutterClean/presentation/dependencies/validation.dart';
import 'package:flutterClean/validation/validators/validators.dart';

import 'package:test/test.dart';

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
    test('Should return null if value is bigger than min size', () {
      expect(sut.validate(faker.randomGenerator.string(10, min: 6)), null);
    });
  });
}
