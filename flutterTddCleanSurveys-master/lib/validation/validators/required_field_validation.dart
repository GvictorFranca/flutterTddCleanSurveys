import 'package:equatable/equatable.dart';

import '../../presentation/dependencies/dependencies.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  List get props => [field];

  RequiredFieldValidation(this.field);

  ValidationError validate(String value) =>
      value?.isNotEmpty == true ? null : ValidationError.requiredField;
}
