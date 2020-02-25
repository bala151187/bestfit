import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../providers/address.dart';

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import '../widgets/address_item.dart';

import '../screens/edit_address_screen.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    //Future.delayed(Duration.zero).then((_) async {
    _isLoading = true;
    Provider.of<Orders>(context, listen: false).getOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<Address>(context, listen: false).getAddress().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    final addressData = Provider.of<Address>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: addressData.addr.isEmpty ? 0 : 1,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : addressData.addr.isEmpty
                    ? askAddress()
                    : ListView.builder(
                        itemCount: addressData.addr.length,
                        itemBuilder: (ctx, index) => AddressItems(
                          addressData.addr[index],
                        ),
                      ),
          ),
          Expanded(
            flex: 3,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, index) => OrderItem(
                      orderData.orders[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget askAddress() {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: Text('Add Delivery Address'),
      subtitle: Divider(),
      trailing: IconButton(
        icon: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(EditAddressScreen.routeName);
        },
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
