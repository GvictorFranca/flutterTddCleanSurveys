import 'package:faker/faker.dart';
import 'package:flutterClean/data/usecases/load_surveys/load_surveys.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:flutterClean/domain/helpers/helpers.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();
      await local.save(surveys);
      return surveys;
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
      await local.validate();
      return await local.load();
    }
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysSpy remote;
  RemoteLoadSurveysWithLocalFallback sut;
  LocalLoadSurveysSpy local;
  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: faker.date.dateTime(),
            didAnswer: faker.randomGenerator.boolean())
      ];

  PostExpectation mockRemoteLoadCall() => when(remote.load());

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  PostExpectation mockRemoteLocalLoadCall() => when(local.load());

  void mockLocalLoad() {
    localSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => localSurveys);
  }

  void mockRemoteLoadError(DomainError error) {
    mockRemoteLoadCall().thenThrow((_) async => error);
  }

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    local = LocalLoadSurveysSpy();
    mockRemoteLoad();
    mockLocalLoad();
  });
  test('Should call  remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call  local save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return  remote surveys', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow  if remote remote load throws AccessDeniedError',
      () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.load();

    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });
}
