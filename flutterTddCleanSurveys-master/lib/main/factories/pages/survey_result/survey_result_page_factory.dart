import 'package:flutter/material.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'survey_result_presenter_factory.dart';

Widget makeSurveyResultPage() {
  return SurveyResultPage(
      makeGetxSurveysResultPresenter(Get.parameters['survey_id']));
}
