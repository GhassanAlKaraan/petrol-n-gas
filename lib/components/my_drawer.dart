import 'package:flutter/material.dart';
import 'package:petrol_n_gas/pages/admin/editproducts_page.dart';
import 'package:petrol_n_gas/pages/edit_profile.dart';
import 'package:petrol_n_gas/pages/home_page.dart';
import 'package:petrol_n_gas/services/firebase/auth/firebase_auth_helper.dart';
import 'package:petrol_n_gas/utility/utils.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void _signout() {
    FirebaseAuthHelper().logout();
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
                    Utility.launchPage(context, const HomePage());
                  },
                ),
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
                  height: 40,
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Manage Products *',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pop(context);
                    Utility.launchPage(context, const EditProductsPage());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Manage orders *',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Handle the tap event for this Tile
                    Navigator.pop(context);
                    Utility.showSnackBar(context, "Feature is not ready yet");
                    //TODO: Utility.launchPage(context, const EditOrdersPage());
                  },
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey[500],
                ),
                const Text("User settings",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const SizedBox(
                  height: 40,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Profile', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pop(context);
                    Utility.launchPage(context, EditProfilePage());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out', style: TextStyle(fontSize: 18)),
                  onTap: () => Utility.showAlertDialog(
                      context, _signout, "Sign Out"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
