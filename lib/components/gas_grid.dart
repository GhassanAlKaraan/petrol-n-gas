import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petrol_n_gas/components/grocery_item_tile.dart';
import 'package:petrol_n_gas/model/cart_model.dart';
import 'package:petrol_n_gas/model/product_model.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:petrol_n_gas/utility/constants.dart';
import 'package:provider/provider.dart';

final List<Color> _colorList = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.purple,
  Colors.orange
];

class GasGridView extends StatelessWidget {
  const GasGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getGasProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No products found',
              style: kTxtBig,
            ),
          );
        } else {
          final docs = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            primary: true, // scrollable : true
            shrinkWrap: true,
            itemCount: docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.2,
            ),
            itemBuilder: (context, index) {
              DocumentSnapshot ds = docs[index];
              // String docId = ds.id;
              String name = ds['name'];
              int price = ds['price']; //int to String.
              return GroceryItemTile(
                itemName: name,
                itemPrice: "$price",
                imagePath: 'assets/images/gas-cylinder.png',
                color: _colorList[index%6],
                onPressed: () {
                  final ProductModel product = ProductModel(
                      name: name,
                      price: price,
                      quantity: 1, //todo: choose quantity
                      category: "gas");
                  Provider.of<CartModel>(context, listen: false)
                      .addProductToCart(product);
                },
              );
            },
          );
        }
      },
    );
  }
}
