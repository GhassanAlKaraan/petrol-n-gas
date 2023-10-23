import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  // list of items on sale
  final List _shopItems = const [
    // [ itemName, itemPrice, imagePath, color ]
    ["Oil", "4.00", "lib/images/oil-barrel.png", Colors.green],
    ["Benzine 95", "2.50", "lib/images/petrol.png", Colors.yellow],
    ["Benzine 97", "12.80", "lib/images/petrol.png", Colors.red],
    ["Gas", "1.00", "lib/images/gas-cylinder.png", Colors.blue],
    ["Gas", "1.00", "lib/images/gas-cylinder.png", Colors.blue],
    ["Gas", "1.00", "lib/images/gas-cylinder.png", Colors.blue],
  ];

  // list of cart items
  List _cartItems = [];

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  // add item to cart
  void addItemToCart(int index) {
    _cartItems.add(_shopItems[index]);
    notifyListeners();
  }

  // remove item from cart
  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // calculate total price
  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += double.parse(cartItems[i][1]);
    }
    return totalPrice.toStringAsFixed(2);
  }
}