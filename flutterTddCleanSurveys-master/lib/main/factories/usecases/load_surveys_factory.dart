import 'package:flutterClean/data/usecases/load_surveys/load_surveys.dart';
import 'package:flutterClean/data/usecases/usecases.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:flutterClean/main/composite/composite.dart';
import 'package:flutterClean/main/factories/cache/cache.dart';

import 'package:flutterClean/main/factories/http/http.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'));
}

LoadSurveys makeLocalLoadSurveys() =>
    LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
        remote: makeRemoteLoadSurveys(), local: makeLocalLoadSurveys());
