import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterClean/presentation/dependencies/dependencies.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({@required this.field, @required this.size});

  List<Object> get props => [field, size];

  ValidationError validate(String value) {
    return value != null && value.length >= size
        ? null
        : ValidationError.invalidField;
  }
}
