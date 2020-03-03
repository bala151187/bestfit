import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

import '../providers/orders.dart';
import '../providers/address.dart';

class OrderConfirmationScreen extends StatefulWidget {
  static const routeName = '/order-confirm';

  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  var _isLoading = false;
  OrderItem _orderDetails;
  AddressItem _addressDetails;
  @override
  void didChangeDependencies() {
    final orderId = ModalRoute.of(context).settings.arguments as String;
    Provider.of<Orders>(context).getOrders();
    if (orderId != null) {
      _orderDetails =
          Provider.of<Orders>(context, listen: false).findById(orderId);
    }
    super.didChangeDependencies();
  }

  void emailCall() async {
    final MailOptions mailOptions = MailOptions(
      body: 'a long body for the email <br> with a subset of HTML',
      subject: 'the Email Subject',
      isHTML: true,
      bccRecipients: ['other@example.com'],
      ccRecipients: ['third@example.com'],
      recipients: ['${_orderDetails.address.emailId}'],
    );
    // final Email email = Email(
    //   body: 'JK order ',
    //   subject: 'JK order ',
    //   recipients: ['balamurugan151187@gmail.com'],
    //   // cc: ['cc@example.com'],
    //   // bcc: ['bcc@example.com'],
    //   // attachmentPath: '/path/to/attachment.zip',
    //   isHTML: false,
    // );
    await FlutterMailer.send(mailOptions);
  }

  @override
  Widget build(BuildContext context) {
    //emailCall();
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.done),
                title: Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                subtitle: Divider(),
                // trailing: Icon(Icons.done),
              ),
              FutureBuilder(
                future: Provider.of<Orders>(context, listen: false)
                    .getOrders()
                    .then((_) {
                  setState(() {
                    _isLoading = false;
                  });
                }),
                builder: (ctx, snapshot) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  height: 100,
                  child: ListView(
                    children: <Widget>[
                      Text(
                        'Order number : ${_orderDetails.orderId}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Payment Status : ${_orderDetails.paymentId}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
          Expanded(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.done),
                  title: Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: Divider(),
                  // trailing: Icon(Icons.done),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  height: 130,
                  child: ListView(
                    children: <Widget>[
                      // Text(_orderDetails.address.addressLine1),
                      Text(
                        _orderDetails.address.name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _orderDetails.address.addressLine1,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _orderDetails.address.addressLine2,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _orderDetails.address.city,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _orderDetails.address.state,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _orderDetails.address.phoneNumber.toString(),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.done),
                  title: Text(
                    'Delivery Timings',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: Divider(),
                  // trailing: Icon(Icons.done),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  height: 100,
                  child: ListView(
                    children: <Widget>[
                      Text(
                        'Product will be delivered in 4 - 5 days',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
