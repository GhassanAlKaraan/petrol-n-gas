import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petrol_n_gas/components/my_textfield.dart';
import 'package:petrol_n_gas/components/product_item_tile.dart';
import 'package:petrol_n_gas/model/cart_model.dart';
import 'package:petrol_n_gas/model/product_model.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:petrol_n_gas/utility/constants.dart';
import 'package:petrol_n_gas/utility/utils.dart';
import 'package:provider/provider.dart';

final List<Color> _colorList = [
  Colors.green,
  Colors.indigo,
  Colors.purple,
];


class ProductGridView extends StatefulWidget {
  const ProductGridView({
    super.key,
    required this.productCategory,
  });

  final String productCategory;

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getProductsStreamByCategory(widget.productCategory),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong', style: kTxtBig),
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
              double price = ds['price'].toDouble();
              int quantity = ds['quantity'];
              String imageFlag = ds['imageFlag'];
              String category = ds['category'];

              return ProductItemTile(
                itemName: name,
                itemPrice: price.toString(),
                imagePath: 'assets/images/$imageFlag.png',
                color: _colorList[index % 3],
                onPressed: () {
                  int newQuantity = 1;
                  double newPrice = 0;
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: Text(
                                'Choose quantity',
                                style: kTxtNormal,
                              ),
                              content: MyTextField(
                                controller: _quantityController,
                                isObscure: false,
                                labelText: widget.productCategory == "petrol"? "$quantity Liters available.": "$quantity available.",
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _quantityController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        newQuantity =
                                            int.parse(_quantityController.text);

                                        newPrice = newQuantity * price;

                                        if (newQuantity > quantity) {
                                          Utility.showSnackBar(context,
                                              "Not enough quantity available.");
                                          return;
                                        }
                                        if (newQuantity <= 0) {
                                          Utility.showSnackBar(
                                              context, "Invalid quantity.");
                                          return;
                                        }
                                        final ProductModel product =
                                            ProductModel(
                                                name: name,
                                                price: newPrice,
                                                quantity: newQuantity,
                                                imageFlag: imageFlag,
                                                category: category);
                                        Provider.of<CartModel>(context,
                                                listen: false)
                                            .addProductToCart(product);
                                        _quantityController.clear();
                                        Navigator.pop(context);
                                        Utility.showSnackBar(context, "Done");
                                      },
                                      child: const Text('Add', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )
                              ]));
                },
              );
            },
          );
        }
      },
    );
  }
}
