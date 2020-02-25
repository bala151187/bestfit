import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import '../providers/orders.dart' as ord;
import '../providers/address.dart';

import '../screens/order_confirmation_screen.dart';

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
      },
      "notes": {"shipping address": "note value"}
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
      _paymentStatus = true;
      Provider.of<ord.Orders>(context, listen: false)
          .updateOrder(widget.order.id, _paymentStatus, response.paymentId);

      final addressData =  Provider.of<Address>(context,listen: false);
      Provider.of<ord.Orders>(context, listen: false)
          .updateOrderAddress(widget.order.id, addressData.addr[0]);

      Navigator.of(context)
          .pushNamed(OrderConfirmationScreen.routeName,
              arguments: widget.order.id)
          .then((value) {});
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
    //final String oderId = 'Order-${DateFormat('hhmmssm').format(DateTime.now())}';
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.order.orderId,
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
                Text('Total: \$${widget.order.amount.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon:
                  Icon(!widget.order.paymentStatus ? Icons.delete : Icons.done),
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
          // FutureBuilder(
          //     future: Provider.of<ord.Orders>(context).getOrders(),
          //     builder: (ctx,snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator()) ):
          //  !widget.order.paymentStatus

          FutureBuilder(
              future: Provider.of<ord.Orders>(context).getOrders(),
              builder: (ctx, snapshot) => Row(
                    children: <Widget>[
                      !widget.order.paymentStatus
                          ? FlatButton(
                              child: Text('Make Payment'),
                              onPressed: () {
                                openCheckout();
                              },
                              textColor: Theme.of(context).primaryColor,
                            )
                          : FlatButton(
                              child: Text('Order Placed'),
                              textColor: Theme.of(context).accentColor,
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    OrderConfirmationScreen.routeName,
                                    arguments: widget.order.id);
                              },
                            ),
                    ],
                  ))
        ],
      ),
    );
  }
}
