import 'package:flutterClean/presentation/dependencies/validation.dart';
import 'package:flutterClean/validation/validators/validators.dart';

import 'package:test/test.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', fieldToCompare: 'other_field');
  });

  group('Error if value is empty or null', () {
    test('Should return null on invalid cases', () {
      expect(sut.validate({'any_field': 'any_value'}), null);
      expect(sut.validate({'other_field': 'any_value'}), null);
      expect(sut.validate({}), null);
    });
    test('Should return error if value is not equal', () {
      final formData = {'any_field': 'any_value', 'other_field': 'other_value'};
      expect(sut.validate(formData), ValidationError.invalidField);
    });
    test('Should return null if values are not equal', () {
      final formData = {'any_field': 'any_value', 'other_field': 'any_value'};
      expect(sut.validate(formData), null);
    });
  });
}
