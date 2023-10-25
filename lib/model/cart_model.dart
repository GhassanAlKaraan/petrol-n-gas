import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  // list of items on sale
  final List _shopItems = const [
    // [ itemName, itemPrice, imagePath, color ]

    //Todo: Get data from firestore
    ["Oil", "4.00", "assets/images/oil-barrel.png", Colors.green],
    ["Benzine 95", "2.50", "assets/images/petrol.png", Colors.yellow],
    ["Benzine 97", "12.80", "assets/images/petrol.png", Colors.red],
    ["Gas", "1.00", "assets/images/gas-cylinder.png", Colors.blue],
    ["Gas 2", "1.00", "assets/images/gas-cylinder.png", Colors.blue],
    ["Gas 3", "1.00", "assets/images/gas-cylinder.png", Colors.blue],
  ];

  // list of cart items
  // ignore: prefer_final_fields
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


  //Todo: add order to firestore DB
  // calculate total price
  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += double.parse(cartItems[i][1]);
    }
    return totalPrice.toStringAsFixed(2);
  }
}
