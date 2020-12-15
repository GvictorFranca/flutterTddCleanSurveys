import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Validation {
  String validate({@required String fields, @required String value});
}

class StreamingLoginPresenter {
  final Validation validation;
  StreamingLoginPresenter({
    @required this.validation,
  });
  void validateEmail(String email) {
    validation.validate(fields: 'email', value: email);
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  test('Should call validation with correct email', () {
    final validation = ValidationSpy();
    final sut = StreamingLoginPresenter(validation: validation);
    final email = faker.internet.email();
    sut.validateEmail(email);

    verify(validation.validate(fields: 'email', value: email)).called(1);
  });
}
