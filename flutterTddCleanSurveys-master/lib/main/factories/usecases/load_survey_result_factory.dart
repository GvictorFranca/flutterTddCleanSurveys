import 'package:flutterClean/data/usecases/usecases.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:flutterClean/main/composite/composite.dart';
import 'package:flutterClean/main/factories/cache/cache.dart';

import 'package:flutterClean/main/factories/http/http.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'));
}

LoadSurveyResult makeLocalLoadSurveyResult(String surveyId) =>
    LocalLoadSurveyResult(cacheStorage: makeLocalStorageAdapter());

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) =>
    RemoteLoadSurveyResultWithLocalFallback(
      remote: makeRemoteLoadSurveyResult(surveyId),
      local: makeLocalLoadSurveyResult(surveyId),
    );
