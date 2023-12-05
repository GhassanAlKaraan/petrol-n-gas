// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petrol_n_gas/components/loading_button.dart';
import 'package:petrol_n_gas/components/my_button.dart';
import 'package:petrol_n_gas/components/my_textfield.dart';
import 'package:petrol_n_gas/pages/home_page.dart';
import 'package:petrol_n_gas/services/firebase/firestore/firestore_service.dart';
import 'package:petrol_n_gas/utility/constants.dart';
import 'package:petrol_n_gas/utility/utils.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? currentUserName; // for loading on init.
  TextEditingController userNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

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
      userNameController.text = userName;
    });
  }

  _updateUserName(String userName) async {
    _toggleButtonState();
    String emailAddress = await _getCurrentUserEmail();
    if (userNameController.text.isEmpty) {
      Utility.showAlert(context, "User name is empty");
      _toggleButtonState();
      return;
    }
    try {
      firestoreService.updateUserName(emailAddress.trim(), userName);
      Utility.showSnackBar(context, "Done");
    } on FirebaseFirestore catch (e) {
      Utility.showSnackBar(context, "Failed to update user name");
      print(e);
    } finally {
      _toggleButtonState();
    }
    Utility.launchPage(context, const HomePage());
    //Navigator.of(context).pop(); // This won't rebuild the homepage.
  }

  _saveData({required String userName}) {
    _updateUserName(userName);
  }

  bool isButtonClicked = false;

  void _toggleButtonState() {
    setState(() {
      isButtonClicked = !isButtonClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Utility.replacePage(context, const HomePage());
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: currentUserName == null
            ? const Center(
                child: SizedBox(
                    width: 40, height: 40, child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  Text(
                    "User Name",
                    style: kTxtBig,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                      isObscure: false,
                      controller: userNameController,
                      labelText: ""),
                  const SizedBox(height: 50),
                  isButtonClicked
                      ? const LoadingButton(text: "Wait")
                      : MyButton(
                          text: "Save",
                          onTap: () =>
                              _saveData(userName: userNameController.text))
                ],
              ),
      )),
    );
  }
}
