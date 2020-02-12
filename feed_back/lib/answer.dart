import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function answerQuestionIndex;
  final String answerText;
  Answer(this.answerQuestionIndex,this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        child: Text(answerText),
        onPressed: answerQuestionIndex,
        color: Colors.blue,
      ),
    );
  }
}
