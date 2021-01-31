import 'package:flutterClean/data/http/http.dart';
import 'package:flutterClean/data/models/models.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:flutterClean/domain/helpers/helpers.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';

import 'package:meta/meta.dart';

class RemoteLoadSurveysResult implements LoadSurveysResult {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveysResult({@required this.url, @required this.httpClient});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final json = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
