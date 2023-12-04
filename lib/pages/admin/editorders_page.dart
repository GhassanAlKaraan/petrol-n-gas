// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:petrol_n_gas/utility/constants.dart';
import 'package:petrol_n_gas/utility/utils.dart';

class EditOrdersPage extends StatefulWidget {
  const EditOrdersPage({super.key});

  @override
  EditOrdersPageState createState() => EditOrdersPageState();
}

class EditOrdersPageState extends State<EditOrdersPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Orders',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getOrders(),
          builder: (context, snapshot) {
            // CASE: ERROR
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            // CASE: NO DATA
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // CASE: HAS DATA
            final List<DocumentSnapshot> orders = snapshot.data!.docs;
            // Snapshot of docs

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final String orderDocId = orders[index].id;
                // Document Content of type Object?, representing the fields
                final order = orders[index].data();

                // Child Collection: List of Orders
                final CollectionReference orderProducts =
                    orders[index].reference.collection('orderProducts');

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OrderCard(
                    orderDocId: orderDocId,
                    orderData: order, // the fields
                    products: orderProducts,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({
    super.key,
    required this.orderData,
    required this.products,
    required this.orderDocId,
  });

  final String orderDocId;
  final dynamic orderData;
  final CollectionReference products;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  Future<List<DocumentSnapshot>> getAllProducts() async {
    final querySnapshot = await widget.products.get();
    return querySnapshot.docs;
  }

  // to get each document data: prod = querySnapshot.docs[index].data();
  String convertOrderDate(dynamic orderData) {
    final Timestamp ts = orderData['orderDate'];
    final DateTime dt = ts.toDate();
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  final FirestoreService firestoreService = FirestoreService();

  _approveOrder(context) async {
    try {
      await firestoreService.approveOrder(widget.orderDocId);
      print("Order Approved");
    } catch (e) {
      print("Order approval failed");
      Utility.showSnackBar(context, "Could not approve order");
    }
  }

  //List of maps
  List<Map<String, dynamic>> productsList = [];

  List<Map<String, dynamic>> _getOrderProducts(
      List<DocumentSnapshot> orderProducts) {
    List<Map<String, dynamic>> productsData = [];

    for (DocumentSnapshot doc in orderProducts) {
      Map<String, dynamic> productMap = {
        'category': doc['category'],
        'quantity': doc['quantity'],
        'name': doc['name'],
        'price': doc['price'],
        'imageFlag': doc['imageFlag'],
      };
      productsData.add(productMap);
    }

    return productsData;
  }

//! CAUTION !//
  _finishOrder(
      List<Map<String, dynamic>> productsList, String orderDocId) async {
    for (Map<String, dynamic> map in productsList) {
      try {
        await firestoreService.updateProductByName(map);
      } on FirebaseFirestore catch (e) {
        print("MASSIVE ERROR");
        print(e);
      }
    }

    await firestoreService.deleteOrder(orderDocId);
  }

  Future<void> showOrderProducts(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Adjust the radius as needed
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Products',
                style: kTxtNormal,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _finishOrder(productsList, widget.orderDocId);
                    
                  },
                  icon: const Icon(
                    Icons.check_box,
                    size: 36,
                  ))
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Column(
              children: [
                const Text("User:"),
                Text(
                  widget.orderData['email'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<DocumentSnapshot>>(
                    future: getAllProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final orderProducts = snapshot.data ?? [];

                          print("!!! ATTEMPT !!!");
                          productsList = _getOrderProducts(orderProducts);

                          print("Saving list of maps was successful");
                          return SingleChildScrollView(
                            child: ListBody(
                              children: orderProducts
                                  .map((doc) => doc['category'] == 'petrol'
                                      ? Text(
                                          '${doc['quantity']} Liters of ${doc['name']}')
                                      : Text(
                                          '${doc['quantity']} Pieces of ${doc['name']}'))
                                  .toList(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                      child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff214183),
                    ),
                  )),
                ),
                TextButton(
                  onPressed: () {
                    _approveOrder(context);
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                      child: Text(
                    'Approve',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff214183),
                    ),
                  )),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOrderApproved = widget.orderData['orderStatus'] == true;
    final String status =
        isOrderApproved ? "Ready to Deliver" : "Pending Approval";
    final Color? statusColor =
        isOrderApproved ? Colors.cyan[100] : Colors.white10;

    return ListTile(
      onTap: () => showOrderProducts(context),
      title: Text(
        convertOrderDate(widget.orderData),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Text(
        status,
        style: GoogleFonts.notoSerif(
          fontSize: 18,
        ),
      ),
      trailing: Text(
        '\$${widget.orderData['totalAmount'].toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Colors.black),
      ),
      tileColor: statusColor,
      leading: isOrderApproved ? const Icon(Icons.delivery_dining) : null,
    );
  }
}
