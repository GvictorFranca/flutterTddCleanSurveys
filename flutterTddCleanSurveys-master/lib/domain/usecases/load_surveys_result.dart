import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class LoadSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({String surveyId});
}
