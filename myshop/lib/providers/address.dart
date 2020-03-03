import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddressItem {
  final String id;
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final int phoneNumber;
  final String emailId;

  AddressItem({
    this.id,
    this.name,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.phoneNumber,
    this.emailId,
  });
}

class Address with ChangeNotifier {
  List<AddressItem> _address = [];

  List<AddressItem> get addr {
    return [..._address];
  }

  final String authToken;
  final String userId;

  Address(this.authToken, this.userId);

  Future<void> addAddress(AddressItem address) async {
    final url =
        'https://flutter-e767a.firebaseio.com/address/$userId.json?access_token=$authToken';
    final response = await http.post(
      url,
      body: json.encode(
        {
          'name': address.name,
          'addressLine1': address.addressLine1,
          'addressLine2': address.addressLine2,
          'city': address.city,
          'state': address.state,
          'phoneNumber': address.phoneNumber,
          'emailId': address.emailId,
        }
      ),
    );
    _address.insert(
      0,
      AddressItem(
        name: address.name,
        addressLine1: address.addressLine1,
        addressLine2: address.addressLine2,
        city: address.city,
        state: address.state,
        phoneNumber: address.phoneNumber,
        emailId: address.emailId,
        id: json.decode(response.body)['name'],
      ),
    );

    notifyListeners();
  }

  Future<String> getAddress() async {
    final url =
        'https://flutter-e767a.firebaseio.com/address/$userId.json?access_token=$authToken';
    final response = await http.get(url);
    final List<AddressItem> loadedAddress = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
//print(extractedData);
    extractedData.forEach(
      (addressId, addressData) {
       // print(addressData);
        loadedAddress.add(
          AddressItem(
            id: addressId,
            name: addressData['name'],
            addressLine1: addressData['addressLine1'],
            addressLine2: addressData['addressLine2'],
            city: addressData['city'],
            state: addressData['state'],
            phoneNumber: addressData['phoneNumber'],
            emailId: addressData['emailId'],
          ),
        );
      },
    );
    //print(loadedAddress);
    // final prefs = await SharedPreferences.getInstance();
    // final test = prefs.getString('addressLine1');
    _address = loadedAddress.reversed.toList();
    // print(_address);
  //print(_address);
    notifyListeners();
    return "";
  }

  Future<void> updateAddress(String id, AddressItem newAddress) async {
     final addressIndex = _address.indexWhere((addr) => addr.id == id);
    final url =
        'https://flutter-e767a.firebaseio.com/address/$userId/$id.json?access_token=$authToken';
    await http.patch(
      url,
      body: json.encode({
        'name': newAddress.name,
        'addressLine1': newAddress.addressLine1,
        'addressLine2': newAddress.addressLine2,
        'city': newAddress.city,
        'state': newAddress.state,
        'phoneNumber': newAddress.phoneNumber,
        'emailId': newAddress.emailId,
      }),
    );
    _address[addressIndex] = newAddress;
    notifyListeners();
  }

  AddressItem findById(String id) {
    // print("findById" + _address.toString());
    return _address.firstWhere((address) => address.id == id);
  }
}
