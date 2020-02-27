import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final String weight;
  final double price;
  final String title;
  final int quantity;

  CartItem(
    this.id,
    this.productId,
    this.weight,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int _itemCount = 1;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(
          widget.productId,
        );
      },
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Alert!'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$${widget.price}')),
            ),
            title: Padding(
              padding: EdgeInsets.all(5),
              child: Row(children: <Widget>[
                Text(widget.title),
                Text(widget.weight),
              ],),
              // child: Text(widget.title),
            ),
            subtitle: Text(
              'Total: \$${(widget.price * _itemCount).toStringAsFixed(2)}',
            ),
            trailing: Container(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.quantity != 1
                      ? new IconButton(
                          icon: new Icon(Icons.remove),
                          onPressed: () => setState(
                            () {
                              _itemCount--;
                              Provider.of<Cart>(context, listen: false)
                                  .totalPriceOfAllProducts(widget.productId,
                                      widget.price, _itemCount, "sub");
                            },
                          ),
                        )
                      : new Container(),
                  Text('${widget.quantity} x'),
                  new IconButton(
                    icon: new Icon(Icons.add),
                    onPressed: () => setState(
                      () {
                        _itemCount++;
                        Provider.of<Cart>(context, listen: false)
                            .totalPriceOfAllProducts(widget.productId,
                                widget.price, _itemCount, "add");
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
