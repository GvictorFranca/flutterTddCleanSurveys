import 'package:flutterClean/data/usecases/usecases.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';

import 'package:flutterClean/main/factories/http/http.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
      httpClient: makeHttpAdapter(), url: makeApiUrl('login'));
}
