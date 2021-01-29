import 'package:equatable/equatable.dart';
import 'package:flutterClean/domain/entities/entities.dart';
import 'package:meta/meta.dart';

class SurveyResultEntity {
  final String id;
  final String question;

  final List<SurveyAnwserResult> answers;

  List get props => ['id', 'question', 'dateTime', 'answers'];

  SurveyResultEntity({
    @required this.id,
    @required this.question,
    @required this.answers,
  });
}
