import 'package:faker/faker.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:flutterClean/domain/helpers/helpers.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:flutterClean/presentation/presenters/presenter.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/pages/pages.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LoadSurveysResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveysResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveysResultSpy loadSurveyResult;
  SaveSurveysResultSpy saveSurveyResult;
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;
  String answer;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100),
            ),
            SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100),
            ),
          ]);
  // LOAD RESULT
  PostExpectation mockLoadSurveysResultCall() =>
      when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveysResultCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveyResultError(DomainError error) =>
      mockLoadSurveysResultCall().thenThrow(error);

  // SAVE RESULT

  PostExpectation mockSaveSurveysResultCall() =>
      when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveysResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) =>
      mockSaveSurveysResultCall().thenThrow(error);

  setUp(() {
    answer = faker.lorem.sentence();
    surveyId = faker.guid.guid();
    loadSurveyResult = LoadSurveysResultSpy();
    saveSurveyResult = SaveSurveysResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) =>
      SurveyResultViewModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: [
          SurveyAnswerViewModel(
            image: entity.answers[0].image,
            answer: entity.answers[0].answer,
            isCurrentAnswer: entity.answers[0].isCurrentAnswer,
            percent: '${entity.answers[0].percent}%',
          ),
          SurveyAnswerViewModel(
            answer: entity.answers[1].answer,
            isCurrentAnswer: entity.answers[1].isCurrentAnswer,
            percent: '${entity.answers[1].percent}%',
          ),
        ],
      );
  group('loadData', () {
    test('Should call loadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emits correct events on sucess', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.surveyResultStream,
          emitsInOrder([
            mapToViewModel(loadResult),
            mapToViewModel(saveResult),
          ]));

      await sut.loadData();
      await sut.save(answer: answer);
    });
    test('Should emits correct events on access Denied', () async {
      mockLoadSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });

    test('Should emits correct events on failure', () async {
      mockLoadSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.surveyResultStream.listen(null,
          onError: expectAsync1((error) => expect(
                error,
                UIError.unexpected.description,
              )));

      await sut.loadData();
    });
  });

  group('save', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emits correct events on sucess', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.surveyResultStream,
          emitsInOrder([
            mapToViewModel(loadResult),
            mapToViewModel(saveResult),
          ]));

      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('Should emits correct events on access Denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });

    test('Should emits correct events on failure', () async {
      mockSaveSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.surveyResultStream.listen(null,
          onError: expectAsync1((error) => expect(
                error,
                UIError.unexpected.description,
              )));

      await sut.save(answer: answer);
    });
  });
}
