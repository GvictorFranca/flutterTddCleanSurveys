import 'dart:async';

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
  StreamController<List<SurveyViewModel>> loadSurveysController;

  void initStreams() {
    // emailErrorController = StreamController<UIError>();
    // passwordErrorController = StreamController<UIError>();
    // mainErrorController = StreamController<UIError>();
    // navigateToController = StreamController<String>();
    loadSurveysController = StreamController<List<SurveyViewModel>>();
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
    when(presenter.loadSurveysStream)
        .thenAnswer((_) => loadSurveysController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    // emailErrorController.close();
    // passwordErrorController.close();
    // mainErrorController.close();
    // navigateToController.close();
    loadSurveysController.close();
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

    loadingSurveysController.add(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsOneWidget);
  });
}
