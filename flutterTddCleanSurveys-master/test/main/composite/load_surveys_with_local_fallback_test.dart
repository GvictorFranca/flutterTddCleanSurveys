import 'package:faker/faker.dart';
import 'package:flutterClean/data/usecases/load_surveys/load_surveys.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<void> load() async {
    final surveys = await remote.load();
    await local.save(surveys);
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysSpy remote;
  RemoteLoadSurveysWithLocalFallback sut;
  LocalLoadSurveysSpy local;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: faker.date.dateTime(),
            didAnswer: faker.randomGenerator.boolean())
      ];

  void mockRemoteload() {
    surveys = mockSurveys();
    when(remote.load()).thenAnswer((_) async => surveys);
  }

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    local = LocalLoadSurveysSpy();
    mockRemoteload();
  });
  test('Should call  remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call  local save with remote data', () async {
    await sut.load();

    verify(local.save(surveys)).called(1);
  });
}
