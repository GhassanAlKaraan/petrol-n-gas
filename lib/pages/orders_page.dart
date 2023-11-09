import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<DocumentSnapshot> orders = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      // Document Content
                      final order = orders[index].data();
                      // Child Collection: List of Orders
                      //todo: to be displayed
                      final CollectionReference orderProducts =
                          orders[index].reference.collection('orderProducts');

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OrderCard(
                          orderData: order,
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

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.orderData, required this.products});

  // ignore: prefer_typing_uninitialized_variables
  final orderData;

  //todo: to be displayed
  final CollectionReference products;

  //todo: to be displayed
  Future getAllProducts() async {
    QuerySnapshot querySnapshot = await products.get();
    final List proDocs = querySnapshot.docs;
    return proDocs; //list of documents
  }

  String convertOrderDate(orderData) {
    Timestamp fromDateTimestamp = orderData['orderDate'];
    DateTime fromDateDateTime = fromDateTimestamp.toDate();
    String formattedFromDate =
        DateFormat('yyyy-MM-dd').format(fromDateDateTime);

    return formattedFromDate;
  }

  @override
  Widget build(BuildContext context) {
    final String status;
    final Color? statusColor;
    if (orderData['orderStatus'] == true) {
      status = "Approved!";
      statusColor = Colors.green[100];
    } else {
      status = "Pending Approval";
      statusColor = Colors.white10;
    }
    return status == "Approved!"
        ? ListTile(
            leading: const Icon(Icons.check),
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
                side: const BorderSide(color: Colors.black)),
            tileColor: statusColor)
        : ListTile(
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
                side: const BorderSide(color: Colors.black)),
            tileColor: statusColor);
  }
}
