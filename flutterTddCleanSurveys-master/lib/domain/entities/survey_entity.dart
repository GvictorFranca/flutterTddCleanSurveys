import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SurveyEntity {
  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAwser;

  @override
  List get props => [id, question, dateTime, didAwser];

  SurveyEntity({
    @required this.id,
    @required this.question,
    @required this.dateTime,
    @required this.didAwser,
  });
}
