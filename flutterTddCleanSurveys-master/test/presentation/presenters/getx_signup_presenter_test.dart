import 'package:faker/faker.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:flutterClean/domain/usecases/add_account.dart';

import 'package:flutterClean/presentation/dependencies/validation.dart';
import 'package:flutterClean/presentation/presenters/presenter.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  AddAccountSpy addAccount;
  String email;
  String name;
  String password;
  String passwordConfirmation;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAddAccountCall() => when(addAccount.add(any));

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token: token));
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    sut = GetxSignUpPresenter(validation: validation, addAccount: addAccount);
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAddAccount();
  });

  group('Email Group', () {
    test('Should call Validation with correct email', () {
      sut.validateEmail(email);

      verify(validation.validate(field: 'email', value: email)).called(1);
    });

    test('Should emit invalidFieldError if email is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Should emit requiredFieldError if email is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.emailErrorStream.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Should emit null if validation succeeds', () {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });

  group('Name Group', () {
    test('Should call Validation with correct name', () {
      sut.validateName(name);

      verify(validation.validate(field: 'name', value: name)).called(1);
    });

    test('Should emit invalidFieldError if name is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.nameErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Should emit requiredFieldError if name is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.nameErrorStream.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Should emit null if validation succeeds', () {
      sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateName(name);
      sut.validateName(name);
    });
  });

  group('Password Group', () {
    test('Should call Validation with correct Password', () {
      sut.validatePassword(password);

      verify(validation.validate(field: 'password', value: password)).called(1);
    });

    test('Should emit invalidFieldError if password is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit requiredFieldError if password is empty', () {
      mockValidation(value: ValidationError.requiredField);

      sut.passwordErrorStream.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit null if validation succeeds', () {
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });

  group('Password Confirmation Group', () {
    test('Should call Validation with correct Password', () {
      sut.validatePasswordConfirmation(passwordConfirmation);

      verify(validation.validate(
              field: 'passwordConfirmation', value: passwordConfirmation))
          .called(1);
    });

    test('Should emit invalidFieldError if password is invalid', () {
      mockValidation(value: ValidationError.invalidField);

      sut.passwordConfirmationErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });

    test('Should emit requiredFieldError if password confirmation is empty',
        () {
      mockValidation(value: ValidationError.requiredField);

      sut.passwordConfirmationErrorStream.listen(
          expectAsync1((error) => expect(error, UIError.requiredField)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });

    test('Should emit null if validation succeeds', () {
      sut.passwordConfirmationErrorStream
          .listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
  });
  test('Should call AddAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signup();

    verify(addAccount.add(AddAccountParams(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    ))).called(1);
  });
}