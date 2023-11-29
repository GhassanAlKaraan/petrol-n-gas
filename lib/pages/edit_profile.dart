import 'package:flutter/material.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? currentUserName; // TODO: always null not sure why, to be checked

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  FirestoreService firestoreService = FirestoreService();

  _getUserData() {
    return firestoreService.getUserByEmail;
  }

  _getUserName() async {
    Map<String, dynamic> data = await _getUserData();
    String userName = data['name'];
    setState(() {
      currentUserName = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Center(
        child: currentUserName == null
            ? const SizedBox(height: 20, child: CircularProgressIndicator())
            : Text(currentUserName!.toString()),
      ),
    );
  }
}
