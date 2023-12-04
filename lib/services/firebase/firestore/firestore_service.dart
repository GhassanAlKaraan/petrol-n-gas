// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petrol_n_gas/models/order_model.dart';
import 'package:petrol_n_gas/models/product_model.dart';
import 'package:petrol_n_gas/models/user_model.dart';

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
        .then((value) => print("Product Deleted"))
        .catchError((_) {
      print("Could not delete product");
    });
  }

  ///Get a single element
  // Future<Map<String, dynamic>> getEventById(String docId) async {
  //   DocumentSnapshot ds = await _events.doc(docId).get();
  //   final Map<String, dynamic> map = ds.data() as Map<String, dynamic>;
  //   return map;
  // }

  Future getProductDataByName(String productName) async {
    QuerySnapshot querySnapshot =
        await _products.where('name', isEqualTo: productName).limit(1).get();

    // Check if there's a matching document and return it
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot snapshot = querySnapshot.docs.first;
      String docId = snapshot.id;
      return {'docId': docId, 'snapshot': snapshot};
    } else {
      return null; // No matching document found
    }
  }

  Future updateProductByName(Map<String, dynamic> newData) async {
    //! newData is each product item that we pass from an order
    //name, just to search the db
    String productNameToFind = newData['name'];
    //quantity, to know how much to deduce from the db product data
    int quantityToDeduce = newData['quantity'];

    //now, get the db product data
    Map<String, dynamic> map = await getProductDataByName(productNameToFind);

    //save the docId, and the fields data
    String docId = map['docId'];
    DocumentSnapshot? productSnapshot = map['snapshot'];

    if (productSnapshot != null) {
      //This is the product data from db
      Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;

      //our goal is to just update the quantity in the existing data in db
      int newQuantity = productData['quantity'] - quantityToDeduce;
      if (newQuantity < 0) {
        print("Quantity is now negative");
      }

      ProductModel product = ProductModel(
          imageFlag: productData['imageFlag'],
          name: productData['name'],
          price: productData['price'],
          quantity: newQuantity,
          category: productData['category']);

      //use our previous update method here
      try {
        await updateProduct(docId, product);
      } catch (e) {
        print("Fatal error: could not update product");
      }
    } else {
      print("Fatal Error!!!! No product with the specified name found");
      // No product with the specified name found
    }
  }

  //********** Working with Users **********//

  // Firebase Auth Current Email
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
  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    DocumentSnapshot ds = await _users.doc(email).get();
    try {
      final Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      // In case the data in firestore is badly formatted
      print(e);
      return {};
    }
  }

  ///UPDATE User
  Future<void> updateUserName(String docId, String userName) async {
    return await _users
        .doc(docId)
        .update({'name': userName})
        .then((value) => print("User Name Updated"))
        .catchError((_) {
          print("Could not update User Name");
        });
  }

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

  ///CREATE ORDER products list
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
  Stream<QuerySnapshot> getOrdersByUserEmail(String email) {
    return _orders
        .where('email', isEqualTo: email)
        .orderBy('orderDate') //descending = false
        .snapshots();
  }

  ///READ all orders
  Stream<QuerySnapshot> getOrders() {
    return _orders
        .orderBy('orderDate') //descending = false
        .snapshots();
  }

  /// DELETE
  Future<void> deleteOrder(String docId) async {
    return await _orders
        .doc(docId)
        .delete()
        .then((value) => print("Order Deleted"))
        .catchError((_) {
      print("Could not delete order");
    });
  }

  /// UPDATE
  Future<void> approveOrder(String docId) async {
    return await _orders
        .doc(docId)
        .update({'orderStatus': true})
        .then((value) => print("Order Approved"))
        .catchError((_) {
          print("Could not update order");
        });
  }
}
