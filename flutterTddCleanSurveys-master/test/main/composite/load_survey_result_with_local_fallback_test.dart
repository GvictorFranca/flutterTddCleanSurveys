import 'package:faker/faker.dart';
import 'package:flutterClean/data/usecases/usecases.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallback({@required this.remote});

  Future<void> loadBySurvey({String surveyId}) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

void main() {
  String surveyId;
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote);
  });
  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}
