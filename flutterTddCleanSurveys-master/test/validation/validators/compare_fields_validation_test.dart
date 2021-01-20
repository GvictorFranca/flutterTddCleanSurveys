import 'package:flutterClean/presentation/dependencies/validation.dart';
import 'package:flutterClean/validation/validators/validators.dart';

import 'package:test/test.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', valueToCompare: 'any_value');
  });

  group('Error if value is empty or null', () {
    test('Should return error if value is not equal', () {
      expect(sut.validate('wrong_valid'), ValidationError.invalidField);
    });
    test('Should return null if values are not equal', () {
      expect(sut.validate('wrong_valid'), null);
    });
  });
}
