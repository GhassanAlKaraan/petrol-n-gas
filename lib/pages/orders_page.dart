import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:petrol_n_gas/utility/constants.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  final FirestoreService firestoreService = FirestoreService();
  String email = '';
  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
  }

  getCurrentUserEmail() async {
    String currentEmail = await firestoreService.getCurrentUserEmail();
    setState(() {
      email = currentEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: email.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getOrdersByUserEmail(email),
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
                      // Document Content of type Object?, representing the fields
                      final order = orders[index].data();

                      // Child Collection: List of Orders
                      final CollectionReference orderProducts =
                          orders[index].reference.collection('orderProducts');

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OrderCard(
                          orderData: order, // the fields
                          products: orderProducts, // child collection
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

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orderData,
    required this.products,
  });

  final dynamic orderData;
  final CollectionReference products;

  Future<List<DocumentSnapshot>> getAllProducts() async {
    final querySnapshot = await products.get();
    return querySnapshot.docs;
  }
  // to get each document data: prod = querySnapshot.docs[index].data();
  // to get each field data: prod["productName"]

  String convertOrderDate(dynamic orderData) {
    final Timestamp ts = orderData['orderDate'];
    final DateTime dt = ts.toDate();
    return DateFormat('yyyy-MM-dd').format(dt);
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
          title: Text(
            'Order Products',
            style: kTxtNormal,
          ),
          content: FutureBuilder<List<DocumentSnapshot>>(
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
                  return SingleChildScrollView(
                    child: ListBody(
                      children: orderProducts
                          .map((doc) => doc['category'] == 'petrol'
                              ? Text(
                                  '${doc['quantity']} Liters of ${doc['name']}',
                                  //style: kTxtSmall,
                                )
                              : Text(
                                  '${doc['quantity']} Pieces of ${doc['name']}',
                                  //style: kTxtSmall,
                                ))
                          .toList(),
                    ),
                  );
                }
              }
            },
          ),
          actions: [
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
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOrderApproved = orderData['orderStatus'] == true;
    final String status = isOrderApproved ? "Approved!" : "Pending Approval";
    final Color? statusColor =
        isOrderApproved ? Colors.green[100] : Colors.white10;

    return ListTile(
      onTap: () => showOrderProducts(context),
      title: Text(
        convertOrderDate(orderData),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Text(
        status,
        style: GoogleFonts.notoSerif(
          fontSize: 18,
        ),
      ),
      trailing: Text(
        '\$${orderData['totalAmount'].toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Colors.black),
      ),
      tileColor: statusColor,
      leading: isOrderApproved ? const Icon(Icons.check) : null,
    );
  }
}
