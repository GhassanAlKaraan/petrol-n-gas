// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petrol_n_gas/model/order_model.dart';
import 'package:petrol_n_gas/model/product_model.dart';
import 'package:petrol_n_gas/model/user_model.dart';

class FirestoreService {

  //********** Working with Products/Orders **********//

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  /// CREATE
  Future<void> createProduct(ProductModel product) async {
    return await _products
        .add(product.toMap())
        .then((value) => print("Product Added"))
        .catchError((_) {
      print("Could not add Product");
    });
  }

  ///UPDATE
  Future<void> updateProduct(String docId, ProductModel product) async {
    return await _products
        .doc(docId)
        .update(product.toMap())
        .then((value) => print("Product Updated"))
        .catchError((_) {
      print("Could not update product");
    });
  }

  /// READ
  Stream<QuerySnapshot> getProductsStreamByCategory(String category) {
    return _products
        .where('category', isEqualTo: category)
        .orderBy('name')
        .snapshots();
  }

  /// DELETE
  Future<void> deleteProduct(String docId) async {
    return await _products
        .doc(docId)
        .delete()
        .then((value) => print("Event Deleted"))
        .catchError((_) {
      print("Could not delete event");
    });
  }

  ///Get a single event
  // Future<Map<String, dynamic>> getEventById(String docId) async {
  //   DocumentSnapshot ds = await _events.doc(docId).get();
  //   final Map<String, dynamic> map = ds.data() as Map<String, dynamic>;
  //   return map;
  // }

  //********** Working with Users **********//

  Future<String> getCurrentUserEmail() async {
    User user = FirebaseAuth.instance.currentUser!;
    return user.email!;
  }

  ///Users collection
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  ///CREATE user
  Future createUser(UserModel user) async {
    return await _users
        .doc(user.email)
        .set(user.toMap())
        .then((value) => print("User Added"))
        .catchError((_) {
      print("Could not add User");
    });
  }

  ///READ user
  //TODO: Use it to give proper access

  // Future<Map<String, dynamic>> getUserByEmail(String email) async {
  //   DocumentSnapshot ds = await _users.doc(email).get();
  //   try {
  //     final Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
  //     return data;
  //   } catch (e) {
  //     // In case the data in firestore is badly formatted
  //     print(e);
  //     return {};
  //   }
  // }

  //********* Working with Orders *********//

  ///Orders collection
  final CollectionReference _orders =
      FirebaseFirestore.instance.collection("orders");

  ///CREATE order
  Future<String?> createOrder(OrderModel order) async {
    var result = await _orders.add({
      'email': order.email,
      'totalAmount': order.totalAmount,
      'orderDate': order.orderTime,
      'orderStatus': order.approved, //true or false.
    });
    //* result.id == docId of the order
    createOrderProducts(order, result.id);

    return "Success";
  }
  ///CREATE ORDER, products list
  Future<String?> createOrderProducts(OrderModel order, String? docId) async {
    CollectionReference orderProductsCollection =
        _orders.doc(docId).collection("orderProducts");
    for (ProductModel product in order.orderProducts) {
      orderProductsCollection.add(
        product.toMap(),
      );
    }
    return "Success";
  }

  ///READ orders of a user
  Stream<QuerySnapshot> getOrdersByUserEmail(String email){
    return _orders
        .where('email', isEqualTo: email)
        .orderBy('orderDate') //descending?
        .snapshots();
  }

  ///DELETE order
  // TODO: remove order of a specific user?


}
