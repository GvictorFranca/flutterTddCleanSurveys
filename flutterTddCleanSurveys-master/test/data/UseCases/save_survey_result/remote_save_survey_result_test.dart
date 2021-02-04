import 'package:faker/faker.dart';
import 'package:flutterClean/data/http/http.dart';
import 'package:flutterClean/data/usecases/save_survey_result/save_survey_result.dart';
import 'package:flutterClean/data/usecases/usecases.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteSaveSurveyResult sut;
  HttpClientSpy httpClient;
  String url;
  String answer;

  setUp(() {
    answer = faker.lorem.sentence();
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
  });
  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(
      httpClient.request(
        url: url,
        method: 'put',
        body: {
          'answer': answer,
        },
      ),
    );
  });
}
