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
  MinLenghtValidation sut;

  setUp(() {
    sut = MinLenghtValidation(field: 'any_field', lenght: 5);
  });
  test('Should return error if value is empity', () {
    expect(sut.validate(''), ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), ValidationError.invalidField);
  });
}
