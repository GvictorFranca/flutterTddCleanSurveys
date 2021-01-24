import 'package:meta/meta.dart';

class SurveyViewModel {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  SurveyViewModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });
}
