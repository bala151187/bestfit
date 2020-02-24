import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import './cart.dart';
import './address.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final bool paymentStatus;
  final String paymentId;
  final String orderId;
  final AddressItem address;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    this.paymentStatus,
    this.paymentId,
    this.orderId,
    this.address,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-e767a.firebaseio.com/orders/$userId.json?access_token=$authToken';
    final timestamp = DateTime.now();
    final String customOderId =
        'Order-${DateFormat('hhmmssm').format(DateTime.now())}';
    final response = await http.post(
      url,
      body: json.encode(
        {
          'orderId': customOderId,
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'paymentStatus': false,
          'paymentId': null,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
          'address': {
            'addressLine1': "test",
            'addressLine2': "test",
            'city': "test",
            'state': "test",
            'phoneNumber': 1234567890,
            'emailId': "test",
          }
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts),
    );
    notifyListeners();
  }

  Future<void> getOrders() async {
    final url =
        'https://flutter-e767a.firebaseio.com/orders/$userId.json?access_token=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          orderId: orderData['orderId'],
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          paymentStatus: orderData['paymentStatus'],
          paymentId: orderData['paymentId'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
          address:  AddressItem(
              id: orderData['address']['id'],
              addressLine1: orderData['address']['addressLine1'],
              addressLine2: orderData['address']['addressLine2'],
              city: orderData['address']['city'],
              state: orderData['address']['state'],
              phoneNumber: orderData['address']['phoneNumber'],
              emailId: orderData['address']['emailId'],
            ),
          
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    // print(_orders);
    notifyListeners();
  }

  Future<void> updateOrderAddress(String id, AddressItem newAddress) async {
    final url =
        'https://flutter-e767a.firebaseio.com/orders/$userId/$id/address/.json?access_token=$authToken';
    final orderIndex = _orders.indexWhere((order) => order.id == id);
    if (orderIndex >= 0) {
      await http.patch(
        url,
        body: json.encode(
          {
            'addressLine1': newAddress.addressLine1,
            'addressLine2': newAddress.addressLine2,
            'city': newAddress.city,
            'state': newAddress.state,
            'phoneNumber': newAddress.phoneNumber,
            'emailId': newAddress.emailId
          },
        ),
      );
    }
    //_orders[orderIndex] = newAddress;
    notifyListeners();
  }

  // void removeItem(OrderItem id) {
  //   _orders.remove(id);
  //   notifyListeners();
  // }

  Future<void> updateOrder(
    String id,
    paymentstatus,
    paymentid,
  ) async {
    final orderIndex = _orders.indexWhere((order) => order.id == id);
    if (orderIndex >= 0) {
      final url =
          'https://flutter-e767a.firebaseio.com/orders/$userId/$id.json?access_token=$authToken';
      await http.patch(url,
          body: json.encode({
            'paymentStatus': paymentstatus,
            'paymentId': paymentid,
          }));
      //_orders[orderIndex] = newOrder;
      notifyListeners();
    } else {}
  }

  void removeItem(String id) {
    // print(id);
    final url =
        'https://flutter-e767a.firebaseio.com/orders/$userId/$id.json?access_token=$authToken';
    final existingOrderIndex = _orders.indexWhere((prod) => prod.id == id);
    var existingOrder = _orders[existingOrderIndex];
    _orders.removeAt(existingOrderIndex);
    notifyListeners();
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw Exception();
      }
      existingOrder = null;
    }).catchError((_) {
      _orders.insert(existingOrderIndex, existingOrder);
    });
    notifyListeners();
  }

  OrderItem findById(String id) {
    // print("_orders" + _orders[0].address.addressLine1.toString());
    return _orders.firstWhere((order) => order.id == id);
  }
}
