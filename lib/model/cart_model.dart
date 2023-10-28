// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petrol_n_gas/model/order_model.dart';
import 'package:petrol_n_gas/model/product_model.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:petrol_n_gas/utility/utils.dart';

class CartModel extends ChangeNotifier {
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
  // String calculateTotal() {
  //   double totalPrice = 0;
  //   for (int i = 0; i < cartItems.length; i++) {
  //     totalPrice += cartItems[i].price;
  //   }
  //   return totalPrice.toStringAsFixed(2);
  // }

  double calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += cartItems[i].price;
    }
    return totalPrice;
  }

  final FirestoreService _firestoreService = FirestoreService();

  Future placeOrder(BuildContext context) async {
    if (_cartItems.isEmpty) {
      Utility.showSnackBar(context, "Cart is empty bro!");
      return;
    }
    OrderModel order = OrderModel(
      orderProducts: _cartItems,
      totalAmount: calculateTotal(),
      email: await _firestoreService.getCurrentUserEmail(),
    );

    try {
      await _firestoreService.createOrder(order);

      
      Utility.showSnackBar(context, "Order placed successfully");
    } on FirebaseFirestore catch (e) {
      print(e);
      Utility.showSnackBar(context, "Could not place order");
    }finally{
      _cartItems.clear();
      notifyListeners();
    }
    Navigator.pop(context);
  }
}
