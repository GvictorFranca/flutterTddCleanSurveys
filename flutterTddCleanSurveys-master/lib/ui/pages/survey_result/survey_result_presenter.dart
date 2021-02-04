import 'survey_result_view_model.dart';
import 'package:meta/meta.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Future<void> loadData();
  Future<void> save({@required String answer});
  Stream<SurveyResultViewModel> get surveyResultStream;
}
