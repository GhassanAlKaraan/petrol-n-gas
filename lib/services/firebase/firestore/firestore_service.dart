// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petrol_n_gas/model/user_model.dart';

class FirestoreService {
  //********** Working with Products/Orders **********//
  //todo
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  /// CREATE
  // Future<void> createEvent(EventModel event) async {
  //   return await _events
  //       .add(event.toMap())
  //       .then((value) => print("Event Added"))
  //       .catchError((_) {
  //     print("Could not add Event");
  //   });
  // }

  ///UPDATE
  // Future<void> updateEvent(String docId, EventModel event) async {
  //   return await _events
  //       .doc(docId)
  //       .update(event.toMap())
  //       .then((value) => print("Event Updated"))
  //       .catchError((_) {
  //     print("Could not update note");
  //   });
  // }

  /// READ
  Stream<QuerySnapshot> getPetrolProductsStream() {
    return _products.where('category', isEqualTo: 'petrol').snapshots();
  }
  Stream<QuerySnapshot> getGasProductsStream() {
    return _products.where('category', isEqualTo: 'gas').snapshots();
  }

  /// DELETE
  // Future<void> deleteEvent(String docId) async {
  //   return await _events
  //       .doc(docId)
  //       .delete()
  //       .then((value) => print("Event Deleted"))
  //       .catchError((_) {
  //     print("Could not delete event");
  //   });
  // }

  ///Get a single event
  // Future<Map<String, dynamic>> getEventById(String docId) async {
  //   DocumentSnapshot ds = await _events.doc(docId).get();
  //   final Map<String, dynamic> map = ds.data() as Map<String, dynamic>;
  //   return map;
  // }

  //********** Working with Users **********//

  ///Users collection
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

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
    } catch (e) { // In case the data in firestore is badly formatted
      print(e);
      return {};
    }
  }
}