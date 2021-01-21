import 'package:flutterClean/main/factories/factories.dart';
import 'package:flutterClean/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeSignUpValidations();

    expect(validations, [
      // Name
      RequiredFieldValidation('name'),
      MinLengthValidation(field: 'name', size: 3),
      // Email
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      // Password
      RequiredFieldValidation('password'),
      MinLengthValidation(field: 'password', size: 3),
      // Password Confirmaton
      RequiredFieldValidation('passwordConfirmation'),
      CompareFieldsValidation(
          field: 'passwordConfirmation', fieldToCompare: 'password'),
    ]);
  });
}
