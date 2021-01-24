import 'package:flutterClean/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;

  setUp(() {
    presenter = SurveysPresenterSpy();
  });
  testWidgets('Should call load Surveys on page laod',
      (WidgetTester tester) async {
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
          name: 'surveys',
          page: () => SurveysPage(presenter),
        )
      ],
    );
    await tester.pumpWidget(surveysPage);

    verify(presenter.loadData()).called(1);
  });
}
