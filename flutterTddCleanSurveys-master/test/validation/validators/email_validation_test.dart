import 'package:flutterClean/presentation/dependencies/dependencies.dart';
import 'package:flutterClean/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return null if email is empity', () {
    expect(sut.validate({'any_field': ''}), null);
  });

  test('Should return null if email is empity', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'any_field': 'gvictor@gmail.com'}), null);
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate({'any_field': 'gvictor.gmail.com'}),
        ValidationError.invalidField);
  });
}
