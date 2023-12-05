import 'package:flutter/material.dart';
import 'package:petrol_n_gas/pages/admin/editorders_page.dart';
import 'package:petrol_n_gas/pages/admin/editproducts_page.dart';
import 'package:petrol_n_gas/pages/edit_profile.dart';
import 'package:petrol_n_gas/pages/home_page.dart';
import 'package:petrol_n_gas/pages/intro_screen.dart';
import 'package:petrol_n_gas/services/firebase/auth/firebase_auth_helper.dart';
import 'package:petrol_n_gas/utility/utils.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  MyDrawer({super.key, required this.userRole});

  String? userRole;

  void _signout(context) {
    FirebaseAuthHelper().logout();
    Navigator.of(context).pop();
    Utility.replacePage(context, const IntroScreen());
    Utility.showSnackBar(context, "You're signed out now.");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Image.asset(
              'assets/images/oil-tanker.png',
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              runSpacing: 12,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pop(context);
                    Utility.replacePage(context, const HomePage());
                  },
                ),
                userRole == "admin"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            thickness: 1.0,
                            color: Colors.grey[500],
                          ),
                          const Text("Admin Only",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text('Manage Products',
                                style: TextStyle(fontSize: 18)),
                            onTap: () {
                              Navigator.pop(context);
                              Utility.replacePage(
                                  context, const EditProductsPage());
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text('Manage orders',
                                style: TextStyle(fontSize: 18)),
                            onTap: () {
                              Utility.replacePage(
                                  context, const EditOrdersPage());
                            },
                          ),
                        ],
                      )
                    // : Container(),
                    : userRole == "customer"
                        ? const Row(children: [Text("No Admin Access.")])
                        : const Row(children: [
                            Text(
                              "Loading...",
                              style: TextStyle(fontSize: 20),
                            )
                          ]),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey[500],
                ),
                const Text("User settings",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(
                  height: 40,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Profile', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Utility.replacePage(context, const EditProfilePage());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out', style: TextStyle(fontSize: 18)),
                  onTap: () => Utility.showAlertDialog(
                      context, () => _signout(context), "Sign Out"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
