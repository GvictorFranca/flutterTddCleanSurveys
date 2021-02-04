import 'package:flutterClean/data/usecases/save_survey_result/save_survey_result.dart';

import 'package:flutterClean/domain/usecases/usecases.dart';

import 'package:flutterClean/main/factories/http/http.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) {
  return RemoteSaveSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'));
}
