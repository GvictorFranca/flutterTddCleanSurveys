import 'package:flutterClean/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return null if value is not empity', () {
    expect(sut.validate('any_value'), null);
  });

  test('Should return error if value is empity', () {
    expect(sut.validate(''), 'Campo Obrigatiorio');
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), 'Campo Obrigatiorio');
  });
}
