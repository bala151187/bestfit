import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _myTransaction;
  final deleteTx;
  TransactionList(this._myTransaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      child: _myTransaction.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  "No transactions added yet",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 200,
                    child: Image.asset(
                      'assests/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
              ],
            )
          : ListView.builder(
              itemCount: _myTransaction.length,
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  elevation: 6,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                            child: Text(
                                '\$${_myTransaction[index].amount.toStringAsFixed(2)}')),
                      ),
                    ),
                    title: Text(
                      _myTransaction[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(_myTransaction[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => deleteTx(_myTransaction[index].id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
