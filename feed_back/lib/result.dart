import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final Function resetHandler;
  final int totalscore;
  final String teacherName;

  String get resultPhrase {
    var resultText;
    if (totalscore > 15) {
      resultText = teacherName+" is Awesome";
    } else if (totalscore > 6) {
      resultText = teacherName+" is ok";
    } else {
      resultText = teacherName+" rated as 'Needs Work'";
    }
    return resultText;
  }

  Result(this.resetHandler, this.totalscore, this.teacherName);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          resultPhrase,
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        FlatButton(
          child: Text("Rate Another Staff"),
          textColor: Colors.blue,
          onPressed: resetHandler,
        ),
      ],
    ));
  }
}
