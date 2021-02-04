import 'package:flutter/material.dart';

import '../survey_answer_view_model.dart';
import 'icons/icons.dart';

class SurveyAnswer extends StatelessWidget {
  final SurveyAnswerViewModel viewModel;

  const SurveyAnswer(
    this.viewModel,
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItems() {
      List<Widget> children = [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              viewModel.answer,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Text(
          viewModel.percent,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        viewModel.isCurrentAnswer ? ActiveIcon() : DisabledIcon(),
      ];
      if (viewModel.image != null) {
        children.insert(
          0,
          Image.network(
            viewModel.image,
            width: 40,
          ),
        );
      }
      return children;
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildItems(),
          ),
        ),
        Divider(height: 1)
      ],
    );
  }
}