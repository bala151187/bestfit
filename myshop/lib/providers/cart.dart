import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final String weight;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    this.weight,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String ProductId) {
    _items.remove(ProductId);
    notifyListeners();
  }

// This method to sum up all product price
  void totalPriceOfAllProducts(String productId, double price, int itemCount , String operation) {
    if (_items.containsKey(productId) && operation == "add") {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                weight: existingItem.weight,
                price: existingItem.price,
                quantity: existingItem.quantity + 1,
              ));
      notifyListeners();
    }else{
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                weight: existingItem.weight,
                price: existingItem.price,
                quantity: existingItem.quantity - 1,
              ));
      notifyListeners();
    }
  }

  void addItem(String productId, double price, String title, String weight) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                weight: existingItem.weight,
                price: existingItem.price,
                quantity: existingItem.quantity,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                weight: weight,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

//This is to clear cart screen after clicking ordernow button
  void clear() {
    _items = {};
    notifyListeners();
  }

//This is for UNDO action on the product_overview screen
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                weight: existingCartItem.weight,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
