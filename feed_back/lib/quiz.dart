import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  final List questions;
  final int questionIndex;
  final Function answerQuestionIndex;
  Quiz({this.questions, this.questionIndex, this.answerQuestionIndex});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Question(questions[questionIndex]["question"]),
        ...(questions[questionIndex]["answer"] as List<Map<String,Object>>)
            .map((answerText) {
          return Answer(()=>answerQuestionIndex(answerText["score"]), answerText["rate"]);
        }).toList()
      ],
    );
  }
}
