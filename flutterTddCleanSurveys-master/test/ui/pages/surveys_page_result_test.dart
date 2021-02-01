import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:flutterClean/ui/pages/survey_result/components/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<SurveyResultViewModel> surveysResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysResultController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysResultStream)
        .thenAnswer((_) => surveysResultController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveysResultController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/3',
      getPages: [
        GetPage(
            name: '/survey_result/:survey_id',
            page: () => SurveyResultPage(presenter))
      ],
    );
    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  SurveyResultViewModel makeSurveyResult() =>
      SurveyResultViewModel(surveyId: 'any_id', question: 'Question', answers: [
        SurveyAnswerViewModel(
          image: 'Image 0',
          answer: 'Answer 0',
          isCurrentAnswer: true,
          percent: '60%',
        ),
        SurveyAnswerViewModel(
          answer: 'Answer 1',
          isCurrentAnswer: false,
          percent: '40%',
        ),
      ]);

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveyResult on page load',
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

  testWidgets('Should present error if surveysStream Stream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('Should call LoadSurveysResult on reload button',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysResultController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(
      find.text('Recarregar'),
    );

    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should present valid data if surveysStream Stream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysResultController.add(makeSurveyResult());

    await provideMockedNetworkImages(() async {
      await tester.pump();
    });

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisabledIcon), findsOneWidget);
    final image =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });
}
