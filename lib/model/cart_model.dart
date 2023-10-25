import 'package:flutter/material.dart';
import 'package:petrol_n_gas/model/product_model.dart';

class CartModel extends ChangeNotifier {

  // final List _shopItems = const [
     // [ itemName, itemPrice, imagePath, color ]

  //   ["Oil", "4.00", "assets/images/oil-barrel.png", Colors.green],
  //   ["Benzine 95", "2.50", "assets/images/petrol.png", Colors.yellow],
  //   ["Benzine 97", "12.80", "assets/images/petrol.png", Colors.red],
  //   ["Gas", "1.00", "assets/images/gas-cylinder.png", Colors.blue],
  //   ["Gas 2", "1.00", "assets/images/gas-cylinder.png", Colors.blue],
  //   ["Gas 3", "1.00", "assets/images/gas-cylinder.png", Colors.blue],
  // ];

  // ignore: prefer_final_fields
  List<ProductModel> _cartItems = [];

  get cartItems => _cartItems;

  void addProductToCart(ProductModel p) {
    _cartItems.add(p);
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
      totalPrice += cartItems[i].price;
    }
    return totalPrice.toStringAsFixed(2);
  }

   //Todo: add order to firestore DB
}
