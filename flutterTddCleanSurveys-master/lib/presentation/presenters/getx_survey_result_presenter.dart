import 'package:flutterClean/domain/helpers/helpers.dart';
import 'package:flutterClean/domain/usecases/usecases.dart';
import 'package:flutterClean/presentation/mixins/mixins.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/pages/pages.dart';

import 'package:get/get.dart';
import 'package:meta/meta.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final SaveSurveyResult saveSurveyResult;
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel>();

  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    @required this.saveSurveyResult,
    @required this.loadSurveyResult,
    @required this.surveyId,
  });
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveyResult =
          await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
          surveyId: surveyResult.surveyId,
          question: surveyResult.question,
          answers: surveyResult.answers
              .map((answer) => SurveyAnswerViewModel(
                    image: answer.image,
                    answer: answer.answer,
                    percent: '${answer.percent}%',
                    isCurrentAnswer: answer.isCurrentAnswer,
                  ))
              .toList());
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> save({@required String answer}) async {
    try {
      isLoading = true;
      final surveyResult = await await saveSurveyResult.save(answer: answer);
      _surveyResult.value = SurveyResultViewModel(
          surveyId: surveyResult.surveyId,
          question: surveyResult.question,
          answers: surveyResult.answers
              .map((answer) => SurveyAnswerViewModel(
                    image: answer.image,
                    answer: answer.answer,
                    percent: '${answer.percent}%',
                    isCurrentAnswer: answer.isCurrentAnswer,
                  ))
              .toList());
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}
