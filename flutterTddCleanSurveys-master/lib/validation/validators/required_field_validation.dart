import 'package:equatable/equatable.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  List get props => [field];

  RequiredFieldValidation(this.field);

  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo Obrigatiorio';
  }
}
