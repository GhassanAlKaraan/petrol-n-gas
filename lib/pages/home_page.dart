// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrol_n_gas/components/my_drawer.dart';
import 'package:petrol_n_gas/components/read_data/product_grid.dart';
import 'package:petrol_n_gas/pages/orders_page.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'cart_page.dart';

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
  const ProductGridView(productCategory: "petrol"),
  const ProductGridView(productCategory: "gas"),
  const ProductGridView(productCategory: "accessory"),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // void _signout() {
  //   FirebaseAuthHelper().logout();
  // }

  int currentIndex = 0;
  String currentUserName = " ";
  String userRole = "";
  FirestoreService firestoreService = FirestoreService();

  Future<String> _getCurrentUserEmail() async {
    try {
      return await firestoreService.getCurrentUserEmail();
    } catch (e) {
      print("Could not get current email address");
      return "";
    }
  }

  _getUserData() async {
    String emailAddress = await _getCurrentUserEmail();
    return firestoreService.getUserByEmail(emailAddress);
  }

  _getUserName() async {
    Map<String, dynamic> data = await _getUserData();
    String userName = data['name'];
    setState(() {
      currentUserName = userName;
    });
  }

  _getUserRole() async {
    Map<String, dynamic> data = await _getUserData();
    String newUserRole = data['role'];
    setState(() {
      userRole = newUserRole;
    });
  }

  @override
  void initState() {
    _getUserName();
    _getUserRole();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          'Mecdo Petrol Station',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
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
        ],
      ),
      drawer: MyDrawer(userRole: userRole),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 14.0, 24.0),
            child: FloatingActionButton(
              backgroundColor: Colors.indigo[700],
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    //return const CartPage();
                    return const CartPage();
                  },
                ),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 14.0, 24.0),
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const OrdersPage();
                  },
                ),
              ),
              child: const Icon(
                Icons.notes,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // good morning bro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text('Good morning, $currentUserName'),
          ),

          const SizedBox(height: 4),

          // Let's order for you
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Let's order for you",
              style: GoogleFonts.notoSerif(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(),
          ),

          //const SizedBox(height: 8),

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
        width: currentIndex == index1 ? 160 : 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentIndex == index1 ? Colors.indigo : Colors.orange,
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
