import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './products.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  var _showFavoritesOnly = false;

  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  List<Product> searchItems(String searchText) {
    return _items
        .where((prodItem) => prodItem.title.toLowerCase().contains(searchText))
        .toList();
  }

  Future<void> getProducts([String filter = '']) async {
    var url;
    if (filter == '') {
      url =
          'https://flutter-e767a.firebaseio.com/products.json?access_token=$authToken';
    } else {
      url =
          'https://flutter-e767a.firebaseio.com/products.json?access_token=$authToken&orderBy="type"&equalTo="$filter"';
    }

    try {
      final response = await http.get(url);
      print(response);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://flutter-e767a.firebaseio.com/userFavorites/$userId.json?access_token=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          weight: prodData['weight'],
          description: prodData['description'],
          type: prodData['type'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product product) async {
    final url =
        'https://flutter-e767a.firebaseio.com/products.json?access_token=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'weight': product.weight,
          'description': product.description,
          'type': product.type,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    //  _items.insert(0, newProduct);

    // }).catchError((error) {
    //   throw error;
    // });
    // _items.add(value);
  }

  void showFavoriteOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-e767a.firebaseio.com/products/$id.json?access_token=$authToken';
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'weight': newProduct.weight,
            'description': newProduct.description,
            'type': newProduct.type,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {}
  }

  void deleteProduct(String id) {
    final url =
        'https://flutter-e767a.firebaseio.com/products/$id.json?access_token=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw Exception();
      }
      existingProduct = null;
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
    });
    notifyListeners();
  }
}
