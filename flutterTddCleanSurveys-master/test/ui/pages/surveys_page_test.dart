import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutterClean/ui/helpers/errors/errors.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> surveysController;

  void initStreams() {
    // emailErrorController = StreamController<UIError>();
    // passwordErrorController = StreamController<UIError>();
    // mainErrorController = StreamController<UIError>();
    // navigateToController = StreamController<String>();
    surveysController = StreamController<List<SurveyViewModel>>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    // when(presenter.emailErrorStream)
    //     .thenAnswer((_) => emailErrorController.stream);
    // when(presenter.passwordErrorStream)
    //     .thenAnswer((_) => passwordErrorController.stream);
    // when(presenter.mainErrorStream)
    //     .thenAnswer((_) => mainErrorController.stream);
    // when(presenter.navigateToStream)
    //     .thenAnswer((_) => navigateToController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    // emailErrorController.close();
    // passwordErrorController.close();
    // mainErrorController.close();
    // navigateToController.close();
    surveysController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
          name: 'surveys',
          page: () => SurveysPage(
            presenter,
          ),
        )
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          didAnswer: true,
        ),
        SurveyViewModel(
          id: '1',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: false,
        ),
      ];

  testWidgets('Should call load Surveys on page laod',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
  });
  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if loadSurveys Stream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should present list if loadSurveys succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call load Surveys on reload button',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(
      find.text('Recarregar'),
    );

    verify(presenter.loadData()).called(2);
  });
}
