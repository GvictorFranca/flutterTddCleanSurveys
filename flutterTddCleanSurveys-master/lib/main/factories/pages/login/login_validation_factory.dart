import 'package:flutterClean/main/builder/builders.dart';
import 'package:flutterClean/main/composite/composite.dart';
import 'package:flutterClean/presentation/dependencies/dependencies.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
  ];
}
