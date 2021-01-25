import 'package:flutterClean/data/usecases/usecases.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';

import 'package:flutterClean/main/factories/http/http.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
      httpClient: makeHttpAdapter(), url: makeApiUrl('surveys'));
}
