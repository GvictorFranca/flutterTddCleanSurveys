import 'package:flutter/material.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:flutterClean/ui/pages/survey_result/components/components.dart';

import 'survey_answer.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final void Function({@required String answer}) onSave;

  const SurveyResult({
    @required this.viewModel,
    @required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(viewModel: viewModel);
        }
        final answer = viewModel.answers[index - 1];
        return GestureDetector(
            onTap: () =>
                answer.isCurrentAnswer ? null : onSave(answer: answer.answer),
            child: SurveyAnswer(answer));
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
