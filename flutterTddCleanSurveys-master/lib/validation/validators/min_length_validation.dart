import 'package:meta/meta.dart';

import 'package:flutterClean/presentation/dependencies/dependencies.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';

class MinLenghtValidation implements FieldValidation {
  final String field;
  final int size;

  MinLenghtValidation({@required this.field, @required this.size});

  ValidationError validate(String value) {
    return value != null && value.length >= size
        ? null
        : ValidationError.invalidField;
  }
}
