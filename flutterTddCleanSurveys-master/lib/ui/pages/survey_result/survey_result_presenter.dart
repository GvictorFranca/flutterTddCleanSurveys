abstract class SurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Future<void> loadData();
  Stream<dynamic> get surveysResultStream;
}
