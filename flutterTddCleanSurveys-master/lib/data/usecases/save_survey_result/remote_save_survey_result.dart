import 'package:flutterClean/data/http/http.dart';
import 'package:flutterClean/data/models/models.dart';
import 'package:flutterClean/domain/entities/entities.dart';

import 'package:flutterClean/domain/helpers/helpers.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';

import 'package:meta/meta.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({@required this.url, @required this.httpClient});

  Future<SurveyResultEntity> save(
      {String surveyId, @required String answer}) async {
    try {
      final json = await httpClient
          .request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
