import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petrol_n_gas/pages/auth/login_or_register.dart';
import '../../../pages/home_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // String userRole = ''; // customer or admin

  // FirestoreService firestoreService = FirestoreService();

  // Future<String> _getCurrentUserEmail() async {
  //   print("3. Getting current user email");
  //   try {
  //     return await firestoreService.getCurrentUserEmail();
  //   } catch (e) {
  //     print("Could not get current email address");
  //     return "";
  //   }
  // }

  // _getUserData() async {
  //   print("2. Getting user data");
  //   String emailAddress = await _getCurrentUserEmail();
  //   return firestoreService.getUserByEmail(emailAddress);
  // }

  // _getUserRole() async {
  //   print("1. Getting user role");
  //   Map<String, dynamic> data = await _getUserData();
  //   String newUserRole = data['role'];
  //   setState(() {
  //     userRole = newUserRole;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _getUserRole();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // Listen to changes in the authentication state using FirebaseAuth's stream
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if there is data
          //user logged in
          if (snapshot.hasData) {
            return const HomePage();
            // if (userRole == 'admin') {
            //   return const EditProductsPage();
            // } else {
            //   return const HomePage();
            // }
          }
          //user not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
