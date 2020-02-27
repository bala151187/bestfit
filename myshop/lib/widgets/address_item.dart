import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_address_screen.dart';

import '../providers/address.dart';

class AddressItems extends StatefulWidget {
  final AddressItem address;

  AddressItems(this.address);
  @override
  _AddressItemsState createState() => _AddressItemsState();
}

class _AddressItemsState extends State<AddressItems> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    // print(this.widget.address);
    // emailCall();
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Delivery Address'),
            subtitle: Divider(),
            trailing: IconButton(
              icon: Icon(
                widget.address.addressLine1 != null ? Icons.edit : Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditAddressScreen.routeName,
                    arguments: widget.address.id);
              },
              color: Theme.of(context).primaryColor,
            ),
          ),
          // if (_expanded)
          FutureBuilder(
            future: Provider.of<Address>(context, listen: false).getAddress(),
            builder: (ctx, snapshot) => Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              height: 100,
              child: ListView(
                children: <Widget>[
                  Text(
                    'AddressLine1: ${widget.address.addressLine1}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'AddressLine2: ${widget.address.addressLine2}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'City: ${widget.address.city}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'State: ${widget.address.state}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'PhoneNumber: ${widget.address.phoneNumber}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'EmailID: ${widget.address.emailId}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
