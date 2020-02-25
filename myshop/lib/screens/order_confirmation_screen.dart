import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/address.dart';

class OrderConfirmationScreen extends StatefulWidget {
  static const routeName = '/order-confirm';

  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.done),
                title: Text('Order Details', style: TextStyle(fontSize: 20)),
                // subtitle: Divider(),
                // trailing: Icon(Icons.done),
              ),
              FutureBuilder(
                future: Provider.of<Orders>(context, listen: false).getOrders(),
                builder: (ctx, snapshot) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  height: 100,
                  child: ListView(
                    children: <Widget>[
                      Text('Order number : ${_orderDetails.orderId}'),
                      Text('Payment Status : ${_orderDetails.paymentId}'),
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
                  title:
                      Text('Delivery Address', style: TextStyle(fontSize: 20)),
                  // subtitle: Divider(),
                  // trailing: Icon(Icons.done),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  height: 100,
                  child: ListView(
                    children: <Widget>[
                      // Text(_orderDetails.address.addressLine1),
                       Text(_orderDetails.address.addressLine1),
                       Text(_orderDetails.address.addressLine2),
                        Text(_orderDetails.address.city),
                         Text(_orderDetails.address.state),
                         Text(_orderDetails.address.phoneNumber.toString()),
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
                  title:
                      Text('Delivery Timings', style: TextStyle(fontSize: 20)),
                  // subtitle: Divider(),
                  // trailing: Icon(Icons.done),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  height: 100,
                  child: ListView(
                    children: <Widget>[
                      Text('Product will be delivered in 4 - 5 days'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // SizedBox(
          //   height: 10,
          // ),
          //     ListTile(
          //       leading: Icon(Icons.done),
          //       title: Text('Delivery Address', style: TextStyle(fontSize: 20)),
          //       // subtitle: Divider(),
          //       // trailing: Icon(Icons.done),
          //     ),
          //     Container(
          //       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          //       height: 100,
          //       child: ListView(
          //         children: <Widget>[
          //           Text('Product will be delivered to below address : '),
          //         ],
          //       ),
          //     ),
          //     ListTile(
          //       leading: Icon(Icons.done),
          //       title: Text('Delivery Timings', style: TextStyle(fontSize: 20)),
          //       // subtitle: Divider(),
          //       // trailing: Icon(Icons.done),
          //     ),
          //     Container(
          //       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          //       height: 100,
          //       child: ListView(
          //         children: <Widget>[
          //           Text('Product will be delivered in 4 - 5 days'),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ]));
  }
}
