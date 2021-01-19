import 'package:flutterClean/presentation/dependencies/validation.dart';
import 'package:flutterClean/validation/protocols/protocols.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class MinLenghtValidation implements FieldValidation {
  final String field;
  final int lenght;

  MinLenghtValidation({@required this.field, @required this.lenght});

  ValidationError validate(String value) {
    return null;
  }
}

void main() {
  test('Should return error if value is empity', () {
    final sut = MinLenghtValidation(field: 'any_field', lenght: 5);

    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final sut = MinLenghtValidation(field: 'any_field', lenght: 5);

    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });
}
