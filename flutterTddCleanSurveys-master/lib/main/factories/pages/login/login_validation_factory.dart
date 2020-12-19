import 'package:flutterClean/presentation/dependencies/dependencies.dart';

import 'package:flutterClean/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password')
  ]);
}
