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
  StreamController<List<SurveyViewModel>> surveysController;
  StreamController<bool> isSessionExpiredController;
  StreamController<String> navigateToController;

  void initStreams() {
    surveysController = StreamController<List<SurveyViewModel>>();
    isLoadingController = StreamController<bool>();
    navigateToController = StreamController<String>();
    isSessionExpiredController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStreams() {
    surveysController.close();
    isLoadingController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    initStreams();
    mockStreams();
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      navigatorObservers: [routeObserver],
      getPages: [
        GetPage(
          name: 'surveys',
          page: () => SurveysPage(
            presenter,
          ),
        ),
        GetPage(
          name: 'any_route',
          page: () => Scaffold(
            appBar: AppBar(title: Text('any title')),
            body: Text('Fake Page'),
          ),
        ),
        GetPage(
          name: '/login',
          page: () => Scaffold(
            body: Text('Fake Login'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    closeStreams();
  });

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

  testWidgets('Should call load Surveys on reload',
      (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(presenter.loadData()).called(2);
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

    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should call go to SurveyResult on Survey click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('Fake Page'), findsOneWidget);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/login');
    expect(find.text('Fake Login'), findsOneWidget);
  });
  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/surveys');

    isSessionExpiredController.add(null);
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/surveys');
  });
}
