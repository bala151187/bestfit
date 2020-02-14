import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import '../providers/orders.dart' as ord;

import '../screens/payment_status_screen.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  Razorpay _razorpay;
  var _expanded = false;
  var _paymentStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_P7BpuR30aQc0EB',
      'amount': widget.order.amount * 100, //in the smallest currency sub-unit.
      'name': 'SaraswathyStores',
      'description': 'Test Payment',
      'prefill': {
        'contact': '9123456789',
        'email': 'balamurugan151187@gmail.com'
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // SnackBar.createAnimationController();
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId).then((value) {
      Navigator.of(context)
          .pushNamed(PaymentStatusScreen.routName)
          .then((value) {
        _paymentStatus = true;
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " +
            response.code.toString() +
            " Message: " +
            response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL WALLET: " + response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    // final productId = ModalRoute.of(context).settings.arguments as String;
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<ord.Orders>(context, listen: false).removeItem(
          widget.order.id,
        );
      },
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Alert!'),
            content: Text('Do you want to remove this order?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              )
            ],
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Order-${DateFormat('hhmmss').format(widget.order.dateTime)}',
              ),
              leading: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
              subtitle: //Text(
                  //   DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                  // ),
                  Text('Total: \$${widget.order.amount}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Alert!'),
                      content: Text('Do you want to remove this order?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                        FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                            Provider.of<ord.Orders>(context, listen: false)
                                .removeItem(
                              widget.order.id,
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
                color: Theme.of(context).errorColor,
              ),
            ),
            if (_expanded)
              Container(
                // width: 100,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: min(widget.order.products.length * 20.0 + 10, 100),
                //height: 100,
                child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) => Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prod.quantity}x \$${prod.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.delete),
                              //   onPressed: () {},
                              //   color: Theme.of(context).errorColor,
                              // ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            !_paymentStatus
                ? FlatButton(
                    child: Text('Make Payment'),
                    onPressed: () {
                      openCheckout();
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                : Container(
                    child: Text(
                      'Order Placed',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.title.color),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
