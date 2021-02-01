import 'package:flutter/material.dart';

import '../survey_result_view_model.dart';

class SurveyHeader extends StatelessWidget {
  const SurveyHeader({
    @required this.viewModel,
  });

  final SurveyResultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      decoration:
          BoxDecoration(color: Theme.of(context).disabledColor.withAlpha(90)),
      child: Text(
        viewModel.question,
      ),
    );
  }
}
