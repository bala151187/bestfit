import 'package:flutter/material.dart';

class Staff extends StatelessWidget {
  final Function getStaffName;
  final myController = TextEditingController();

  Staff(this.getStaffName);

  @override
  Widget build(BuildContext context) {
    return Column(
     mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text("Enter the Staff Name",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: myController,
              ),
            ),
            RaisedButton(
              child: Text("OK"),
              onPressed: (() => getStaffName(myController.text)),
              color: Colors.blue,
            )
          ],
        ),
        alignment: Alignment(0.0, 0.0),
      )
    ]);
  }
}
