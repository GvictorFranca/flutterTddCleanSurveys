import 'package:equatable/equatable.dart';
import 'package:flutterClean/presentation/dependencies/validation.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';

class ValidationComposite extends Equatable implements Validation {
  final List<FieldValidation> validations;

  List get props => [validations];

  ValidationComposite(this.validations);

  String validate({@required String field, @required String value}) {
    String error;
    for (final validation in validations.where((v) => v.field == field)) {
      final error = validation.validate(value);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}
