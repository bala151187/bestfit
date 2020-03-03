import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/address.dart';

class EditAddressScreen extends StatefulWidget {
  static const routeName = '/user-address';
  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _form = GlobalKey<FormState>();

  Future<void> _saveNewAddressForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedAddress.id != null) {
      // print(_editedAddress.id);
      await Provider.of<Address>(context, listen: false)
          .updateAddress(_editedAddress.id, _editedAddress);
    } else {
      // print("else block");
      try {
        await Provider.of<Address>(context, listen: false)
            .addAddress(_editedAddress);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  var _editedAddress = AddressItem(
    id: null,
    addressLine1: '',
    addressLine2: '',
    city: '',
    state: '',
    phoneNumber: 0,
    emailId: '',
  );
  var _initValues = {
    'name':'',
    'addressLine1': '',
    'addressLine2': '',
    'city': '',
    'state': '',
    'phoneNumber': '',
    'emailId': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final addressId = ModalRoute.of(context).settings.arguments as String;
      // print(addressId);
      if (addressId != null) {
        _editedAddress =
            Provider.of<Address>(context, listen: false).findById(addressId);
        _initValues = {
          'name': _editedAddress.name,
          'addressLine1': _editedAddress.addressLine1,
          'addressLine2': _editedAddress.addressLine2,
          'city': _editedAddress.city,
          'state': _editedAddress.state,
          'phoneNumber': _editedAddress.phoneNumber.toString(),
          'emailId': _editedAddress.emailId,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNewAddressForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide your name.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedAddress = AddressItem(
                          id: _editedAddress.id,
                          name: value,
                          addressLine1: _editedAddress.addressLine1,
                          addressLine2: _editedAddress.addressLine2,
                          city: _editedAddress.city,
                          state: _editedAddress.state,
                          phoneNumber: _editedAddress.phoneNumber,
                          emailId: _editedAddress.emailId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['addressLine1'],
                      decoration: InputDecoration(labelText: 'AddressLine1'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a valid address.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedAddress = AddressItem(
                          id: _editedAddress.id,
                          name: _editedAddress.name,
                          addressLine1: value,
                          addressLine2: _editedAddress.addressLine2,
                          city: _editedAddress.city,
                          state: _editedAddress.state,
                          phoneNumber: _editedAddress.phoneNumber,
                          emailId: _editedAddress.emailId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['addressLine2'],
                      decoration: InputDecoration(labelText: 'AddressLine2'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a valid address.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedAddress = AddressItem(
                          id: _editedAddress.id,
                          name: _editedAddress.name,
                          addressLine1: _editedAddress.addressLine1,
                          addressLine2: value,
                          city: _editedAddress.city,
                          state: _editedAddress.state,
                          phoneNumber: _editedAddress.phoneNumber,
                          emailId: _editedAddress.emailId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['city'],
                      decoration: InputDecoration(labelText: 'City'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a valid city.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedAddress = AddressItem(
                          id: _editedAddress.id,
                          name: _editedAddress.name,
                          addressLine1: _editedAddress.addressLine1,
                          addressLine2: _editedAddress.addressLine2,
                          city: value,
                          state: _editedAddress.state,
                          phoneNumber: _editedAddress.phoneNumber,
                          emailId: _editedAddress.emailId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['state'],
                      decoration: InputDecoration(labelText: 'State'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a valid state.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedAddress = AddressItem(
                          id: _editedAddress.id,
                          name: _editedAddress.name,
                          addressLine1: _editedAddress.addressLine1,
                          addressLine2: _editedAddress.addressLine2,
                          city: _editedAddress.city,
                          state: value,
                          phoneNumber: _editedAddress.phoneNumber,
                          emailId: _editedAddress.emailId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['phoneNumber'],
                      decoration: InputDecoration(labelText: 'PhoneNumber'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a valid phoneNumber.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedAddress = AddressItem(
                          id: _editedAddress.id,
                          name: _editedAddress.name,
                          addressLine1: _editedAddress.addressLine1,
                          addressLine2: _editedAddress.addressLine2,
                          city: _editedAddress.city,
                          state: _editedAddress.state,
                          phoneNumber: int.parse(value),
                          emailId: _editedAddress.emailId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['emailId'],
                      decoration: InputDecoration(labelText: 'EmailID'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a valid emailID.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedAddress = AddressItem(
                            id: _editedAddress.id,
                            name: _editedAddress.name,
                            addressLine1: _editedAddress.addressLine1,
                            addressLine2: _editedAddress.addressLine2,
                            city: _editedAddress.city,
                            state: _editedAddress.state,
                            phoneNumber: _editedAddress.phoneNumber,
                            emailId: value);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
