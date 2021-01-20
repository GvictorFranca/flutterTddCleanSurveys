import 'package:meta/meta.dart';

import 'package:flutterClean/presentation/dependencies/dependencies.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation(
      {@required this.field, @required this.fieldToCompare});

  ValidationError validate(Map input) => input[field] != null &&
          input[fieldToCompare] != null &&
          input[field] != input[fieldToCompare]
      ? ValidationError.invalidField
      : null;
}
