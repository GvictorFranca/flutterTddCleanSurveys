import 'survey_result_view_model.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Future<void> loadData();
  Stream<SurveyResultViewModel> get surveyResultStream;
}
