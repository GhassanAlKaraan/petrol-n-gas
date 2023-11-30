import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrol_n_gas/components/category_dropdown.dart';
import 'package:petrol_n_gas/components/imageflag_dropdown_2.dart';
import 'package:petrol_n_gas/components/my_drawer.dart';
import 'package:petrol_n_gas/components/my_textfield.dart';
import 'package:petrol_n_gas/components/read_data/product_grid_edit.dart';
import 'package:petrol_n_gas/model/product_model.dart';
import 'package:petrol_n_gas/services/firebase/auth/firebase_auth_helper.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:petrol_n_gas/utility/constants.dart';
import 'package:petrol_n_gas/utility/utils.dart';

//tab bat
class TabBarObjects {
  String text;
  IconData? icon;

  TabBarObjects({required this.text, required this.icon});
}

final List _tabList = [
  TabBarObjects(text: " Petrol", icon: Icons.oil_barrel),
  TabBarObjects(text: " Gas", icon: Icons.oil_barrel_outlined),
  TabBarObjects(text: " Accessories", icon: Icons.pin),
];

List<Widget> _productList = [
  const ProductGridEdit(productCategory: "petrol"),
  const ProductGridEdit(productCategory: "gas"),
  const ProductGridEdit(productCategory: "accessory"),
];

class EditProductsPage extends StatefulWidget {
  const EditProductsPage({super.key});

  @override
  State<EditProductsPage> createState() => _EditProductsPageState();
}

class _EditProductsPageState extends State<EditProductsPage> {
  // String? _selectedCategory;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  // String? _selectedImageFlag;

  void _signout() {
    FirebaseAuthHelper().logout();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = FirestoreService();
    final PageController pageController = PageController(initialPage: 0);
    void goToPage(int index) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Builder(builder: (context) {
            return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          }),
        ),
        title: Text(
          'Admin Control Panel',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: GestureDetector(
              onTap: () =>
                  Utility.showAlertDialog(context, _signout, "Sign Out"),
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          //new vars
          String newCategory = '';
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Create new Product',
                            style: kTxtBig,
                          ),
                        ],
                      ),
                      content: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 450),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 2,
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Category:",
                                      style: TextStyle(fontSize: 20),
                                    ),
// TODO: take it from the category page instead
                                    CategoryDropDown(),
                                  ]),
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

//! ISSUE, it should take the category
//TODO: Add new product based on the page category that is in front of user.
                                  ImageFlagDropDown2(
                                      category:
                                          SelectedCategoryHolder.selectedValue),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  newCategory =
                                      SelectedCategoryHolder.selectedValue;
                                  newQuantity =
                                      int.parse(_quantityController.text);
                                  newPrice =
                                      double.parse(_priceController.text);
                                  newName = _nameController.text.toString();
                                  newImageFlag =
                                      SelectedValue2Holder.selectedValue!;
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
                                  final ProductModel product = ProductModel(
                                      name: newName,
                                      price: newPrice,
                                      quantity: newQuantity,
                                      imageFlag: newImageFlag,
                                      category: newCategory);
                                  await firestoreService.createProduct(product);
                                  Utility.showSnackBar(context, "Done");
                                } catch (e) {
                                  Utility.showSnackBar(
                                      context, "Error updating the product");
                                } finally {
                                  //_toggleButtonState();
                                  _nameController.clear();
                                  _priceController.clear();
                                  _quantityController.clear();
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Create',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        )
                      ]));
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Edit Products",
              style: GoogleFonts.notoSerif(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(),
          ),

          //* Tab bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tabList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: tabBarButtons(
                          _tabList[index], index, () => goToPage(index)),
                    );
                  }),
            ),
          ),
          //* Page view
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _productList,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector tabBarButtons(
      TabBarObjects list, int index1, Function() choose) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex =
              index1; //* the global current index will change depending on the index of the button
          //print(currentIndex);
          choose(); //* the function will be called when the button is pressed
        });
      },
      child: AnimatedContainer(
        curve: Curves.linearToEaseOut,
        width: currentIndex == index1 ? 140 : 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentIndex == index1 ? Colors.blue : Colors.black87,
        ),
        duration: const Duration(milliseconds: 200),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              currentIndex == index1
                  ? _tabList[currentIndex].icon
                  : _tabList[index1].icon,
              color: Colors.white,
            ),
            Expanded(
              child: Text(
                currentIndex == index1 ? " ${_tabList[currentIndex].text}" : "",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
