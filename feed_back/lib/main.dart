import 'package:flutter/material.dart';

import './result.dart';
import './quiz.dart';
import './staff.dart';

void main() => runApp(FeedBack());

class FeedBack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FeedBackState();
  }
}

class FeedBackState extends State<FeedBack> {
  var _questionIndex = 0,
      _totalScore = 0,
      teacherName = "Anitha",
      _staffIndex = 0;

  @override
  Widget build(BuildContext context) {
    var _questions = [
      {
        "question": "Rate " + teacherName + " for lecture",
        "answer": [
          {"rate": "Good", "score": 5},
          {"rate": "average", "score": 2},
          {"rate": "Bad", "score": 0}
        ]
      },
      {
        "question": "Rate " + teacherName + " for explaning on labs",
        "answer": [
          {"rate": "Good", "score": 5},
          {"rate": "average", "score": 2},
          {"rate": "Bad", "score": 0}
        ]
      },
      {
        "question": "Rate " + teacherName + " for taking initiative",
        "answer": [
          {"rate": "Good", "score": 5},
          {"rate": "average", "score": 2},
          {"rate": "Bad", "score": 0}
        ]
      },
      {
        "question": "Rate " + teacherName + " on punctuality",
        "answer": [
          {"rate": "Good", "score": 5},
          {"rate": "average", "score": 2},
          {"rate": "Bad", "score": 0}
        ]
      },
      {
        "question": "Rate " + teacherName + " on discipline",
        "answer": [
          {"rate": "Good", "score": 5},
          {"rate": "average", "score": 2},
          {"rate": "Bad", "score": 0}
        ]
      }
    ];
    void _reset() {
      setState(() {
        _questionIndex = 0;
        _totalScore = 0;
        _staffIndex = 0;
      });
    }

    void _answerQuestionIndex(int score) {
      _totalScore += score;
      setState(() {
        _questionIndex += 1;
      });
    }

    void getStaffName(String name) {
      teacherName = name;
      setState(() {
        _staffIndex += 1;
      });
      print(name);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Feedback Form"),
        ),
        body: _staffIndex == 0
            ? Staff(getStaffName)
            : _questionIndex < _questions.length
                ? Quiz(
                    questions: _questions,
                    questionIndex: _questionIndex,
                    answerQuestionIndex: _answerQuestionIndex)
                : Result(_reset, _totalScore, teacherName),
      ),
    );
  }
}
