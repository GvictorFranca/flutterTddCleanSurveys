import 'package:meta/meta.dart';

import 'package:flutterClean/presentation/dependencies/dependencies.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation(
      {@required this.field, @required this.valueToCompare});

  ValidationError validate(String value) {
    return value == valueToCompare ? null : ValidationError.invalidField;
  }
}
