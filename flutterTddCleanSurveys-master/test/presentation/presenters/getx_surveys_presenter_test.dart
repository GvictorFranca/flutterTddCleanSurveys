import 'package:faker/faker.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:flutterClean/domain/helpers/helpers.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:flutterClean/presentation/presenters/presenter.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveysSpy loadSurveys;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2020, 02, 20),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2021, 02, 20),
          didAnswer: false,
        ),
      ];

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockLoadSurveysCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call loadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emits correct events on sucess', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveyViewModel(
            id: surveys[0].id,
            question: surveys[0].question,
            date: '20 Fev 2020',
            didAnswer: surveys[0].didAnswer,
          ),
          SurveyViewModel(
            id: surveys[1].id,
            question: surveys[1].question,
            date: '20 Fev 2021',
            didAnswer: surveys[1].didAnswer,
          ),
        ])));

    await sut.loadData();
  });

  test('Should emits correct events on failure', () async {
    mockLoadSurveysError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(null,
        onError: expectAsync1((error) => expect(
              error,
              UIError.unexpected.description,
            )));

    await sut.loadData();
  });

  test('Should emits correct events on access Denied', () async {
    mockAccessDeniedError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });

  test('Should go to SurveyResultPage on survey click', () async {
    sut.navigateToStream.listen(
        expectAsync1((page) => expect(page, '/survey_result/any_route')));
    sut.goToSurveyResult('any_route');
  });
}
