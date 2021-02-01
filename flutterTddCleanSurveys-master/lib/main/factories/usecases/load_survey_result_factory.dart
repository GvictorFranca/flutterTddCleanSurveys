import 'package:flutterClean/data/usecases/usecases.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';

import 'package:flutterClean/main/factories/http/http.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveysResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'));
}
