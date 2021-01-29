import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SurveyAnwserResult {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  SurveyAnwserResult({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent,
  });
}
