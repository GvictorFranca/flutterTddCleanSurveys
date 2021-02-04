import 'package:flutterClean/main/factories/factories.dart';
import 'package:flutterClean/presentation/presenters/presenter.dart';
import 'package:flutterClean/ui/pages/pages.dart';

SurveyResultPresenter makeGetxSurveysResultPresenter(String surveyId) {
  return GetxSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
    surveyId: surveyId,
  );
}
