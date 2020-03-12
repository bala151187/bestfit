import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';
// import '../providers/auth.dart';

import '../screens/cart_screen.dart';

enum filterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search";

  @override
  void initState() {
    // Provider.of<ProductsProvider>(context).getProducts();
    // Future.delayed(Duration.zero).then((_){});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      final productFilter = ModalRoute.of(context).settings.arguments as String;
      print(productFilter);
      if (productFilter != null) {
        Provider.of<ProductsProvider>(context)
            .getProducts(productFilter)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        Provider.of<ProductsProvider>(context).getProducts().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
   // final authData = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            focusColor: Theme.of(context).accentColor,
            hintText: searchQuery,
          ),
          controller: _searchQueryController,
          onChanged: (_) {
            setState(() {
              if (_searchQueryController.text.isNotEmpty) {
                ProductsGrid(
                    _showOnlyFavorites, _searchQueryController.text);
              } else {
                ProductsGrid(_showOnlyFavorites, "");
              }
            });
          },
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filterOptions selectedValue) {
              setState(() {
                if (selectedValue == filterOptions.Favorites) {
                  _showOnlyFavorites = true;
                  _searchQueryController.text = "";
                } else {
                  _showOnlyFavorites = false;
                  _searchQueryController.text = "";
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: filterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: filterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites, _searchQueryController.text),
    );
  }
}
