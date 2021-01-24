import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadingController;

  void initStreams() {
    // emailErrorController = StreamController<UIError>();
    // passwordErrorController = StreamController<UIError>();
    // mainErrorController = StreamController<UIError>();
    // navigateToController = StreamController<String>();
    // isFormValidController = StreamController<bool>();
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
    // when(presenter.isFormValidStream)
    //     .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    // emailErrorController.close();
    // passwordErrorController.close();
    // mainErrorController.close();
    // navigateToController.close();
    // isFormValidController.close();
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
}
