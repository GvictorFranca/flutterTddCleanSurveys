import 'package:flutterClean/presentation/presenters/presenter.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import '../../factories.dart';

SurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(
    loadSurveys: makeRemoteLoadSurveys(),
  );
}
