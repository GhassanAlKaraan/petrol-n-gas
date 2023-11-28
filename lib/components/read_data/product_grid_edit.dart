import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petrol_n_gas/components/imageflag_dropdown.dart';
import 'package:petrol_n_gas/components/my_textfield.dart';
import 'package:petrol_n_gas/components/product_item_tile_edit.dart';
import 'package:petrol_n_gas/model/product_model.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:petrol_n_gas/utility/constants.dart';
import 'package:petrol_n_gas/utility/utils.dart';

class ProductGridEdit extends StatefulWidget {
  const ProductGridEdit({
    super.key,
    required this.productCategory,
  });

  final String productCategory;

  @override
  State<ProductGridEdit> createState() => _ProductGridEditState();
}

class _ProductGridEditState extends State<ProductGridEdit> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedImageFlag;
  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  // bool isButtonClicked = false;

  // void _toggleButtonState() {
  //   setState(() {
  //     isButtonClicked = !isButtonClicked;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    return StreamBuilder<QuerySnapshot>(
      stream:
          firestoreService.getProductsStreamByCategory(widget.productCategory),
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
              String docId = ds.id;
              String name = ds['name'];
              double price = ds['price'].toDouble();
              int quantity = ds['quantity'];
              String imageFlag = ds['imageFlag'];
              String category = ds['category'];
              return ProductItemTileEdit(
                itemName: name,
                itemPrice: price.toString(),
                imagePath: 'assets/images/$imageFlag.png',
                color: Colors.black87,
                onPressed: () {
                  //populate editing text fields
                  _nameController.text = name;
                  _priceController.text = price.toString();
                  _quantityController.text = quantity.toString();
                  _selectedImageFlag = imageFlag;

                  //new vars
                  int newQuantity = 1;
                  double newPrice = 0;
                  String newName = '';
                  String newImageFlag = '';
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust the radius as needed
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Manage Product',
                                    style: kTxtBig,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Utility.showAlertDialog(context,
                                            () async {
                                          try {
                                            await firestoreService
                                                .deleteProduct(docId);
                                            Utility.showSnackBar(
                                                context, "Product Deleted");
                                          } catch (e) {
                                            Utility.showSnackBar(context,
                                                "Error deleting product");
                                          } finally {
                                            Navigator.of(context).pop();
                                          }
                                        }, "Delete Product");
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.black,
                                        size: 25,
                                      )),
                                ],
                              ),
                              content: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxHeight: 400),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(
                                        thickness: 2,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "Category: $category",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 22),
                                      MyTextField(
                                          isObscure: false,
                                          controller: _nameController,
                                          labelText: "Product Name"),
                                      const SizedBox(height: 20),
                                      MyTextField(
                                          isObscure: false,
                                          controller: _priceController,
                                          labelText: "Price"),
                                      const SizedBox(height: 20),
                                      MyTextField(
                                          controller: _quantityController,
                                          isObscure: false,
                                          labelText: "Quantity"),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Image Flag:",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          ImageFlagDropDown(
                                            category: category,
                                            selectedVal: _selectedImageFlag,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _nameController.clear();
                                        _priceController.clear();
                                        _quantityController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        //_toggleButtonState();
                                        try {
                                          newQuantity = int.parse(
                                              _quantityController.text);
                                          newPrice = double.parse(
                                              _priceController.text);
                                          newName =
                                              _nameController.text.toString();
                                          newImageFlag = SelectedValueHolder
                                              .selectedValue!;
                                        } catch (e) {
                                          print("Input format error");
                                          //_toggleButtonState();
                                          return;
                                        }
                                        if (newQuantity <= 0 ||
                                            newPrice <= 0 ||
                                            newName.isEmpty) {
                                          Utility.showSnackBar(
                                              context, "Invalid input");
                                          //_toggleButtonState();
                                          return;
                                        }

                                        try {
                                          final ProductModel product =
                                              ProductModel(
                                                  name: newName,
                                                  price: newPrice,
                                                  quantity: newQuantity,
                                                  imageFlag: newImageFlag,
                                                  category: category);
                                          await firestoreService.updateProduct(
                                              docId, product);
                                          Utility.showSnackBar(context, "Done");
                                        } catch (e) {
                                          Utility.showSnackBar(context,
                                              "Error updating the product");
                                        } finally {
                                          //_toggleButtonState();
                                          _nameController.clear();
                                          _priceController.clear();
                                          _quantityController.clear();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Update',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
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
