import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:flutterClean/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<String> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void initStreams() {
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    mainErrorController = StreamController<String>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage()),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);
    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar Senha'),
        matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text');

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });
}
