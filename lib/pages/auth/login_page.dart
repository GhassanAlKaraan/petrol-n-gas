// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:petrol_n_gas/services/firebase/auth/auth_exceptions/auth_exception_handler.dart';
import 'package:petrol_n_gas/services/firebase/auth/auth_exceptions/auth_results_status.dart';
import 'package:petrol_n_gas/services/firebase/auth/firebase_auth_helper.dart';
import 'package:petrol_n_gas/utility/constants.dart';

import '../../components/loading_button.dart';
import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../../utility/utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text fields controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    _toggleButtonState();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Utility.showSnackBar(context, "Please fill in all fields");
      _toggleButtonState();
      return;
    }

    try {
      //clean up code.
      final status =
          await FirebaseAuthHelper().login(email: email, pass: password);

      if (status == AuthResultStatus.successful) {
        Utility.showSnackBar(context, "Success");
        // AuthGate will Navigate to HomePage page after success
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        Utility.showAlert(context, errorMsg);
      }
    } on FirebaseAuth catch (e) {
      print("Login Failed");
      print(e);
    } finally {
      _toggleButtonState();
    }
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const SizedBox(height: 48),
                SizedBox(
                  height: 100,
                  child: Image.asset("assets/images/user.png",
                      fit: BoxFit.contain),
                ),
                const SizedBox(height: 48),
                Text("Please Login", style: kTxtNormal),
                const SizedBox(height: 48),
                MyTextField(
                  isObscure: false,
                  labelText: "Email",
                  controller: emailController,
                ),
                const SizedBox(height: 42),
                MyTextField(
                  isObscure: true,
                  labelText: "Password",
                  controller: passwordController,
                ),
                const SizedBox(height: 52),
                isButtonClicked
                    ? const LoadingButton(text: "Loading")
                    : MyButton(text: "Log In", onTap: _login),
                const SizedBox(height: 52),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: kTxtSmall),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Register",
                          style: kTxtSmall.copyWith(color: Colors.blue)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
