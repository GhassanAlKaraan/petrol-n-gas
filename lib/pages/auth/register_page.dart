// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:petrol_n_gas/components/loading_button.dart';
import 'package:petrol_n_gas/components/my_button.dart';
import 'package:petrol_n_gas/components/my_textfield.dart';
import 'package:petrol_n_gas/services/firebase/auth/auth_exceptions/auth_exception_handler.dart';
import 'package:petrol_n_gas/services/firebase/auth/auth_exceptions/auth_results_status.dart';
import 'package:petrol_n_gas/services/firebase/auth/firebase_auth_helper.dart';
import 'package:petrol_n_gas/utility/constants.dart';
import 'package:petrol_n_gas/utility/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});
  final void Function()? onTap;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text fields controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    _toggleButtonState();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Utility.showSnackBar(context, "Please fill in all fields");
      _toggleButtonState();
      return;
    }

    if (password.isEmpty != confirmPassword.isEmpty) {
      Utility.showSnackBar(context, "Passwords do not match");
      _toggleButtonState();
      return;
    }

    try {
      //clean up code.
      final status =
          await FirebaseAuthHelper().register(email: email, pass: password);

      if (status == AuthResultStatus.successful) {
        Utility.showSnackBar(context, "Success");
        // AuthGate will Navigate to HomePage page after success
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        Utility.showAlert(context, errorMsg);
      }
    } catch (e) {
      print("$e.message");
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

  //! add

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
                Text("Create your customer account", style: kTxtNormal),
                const SizedBox(height: 48),
                MyTextField(
                  isObscure: false,
                  labelText: "Email",
                  controller: emailController,
                ),
                const SizedBox(height: 30),
                MyTextField(
                  isObscure: true,
                  labelText: "Password",
                  controller: passwordController,
                ),
                const SizedBox(height: 30),
                MyTextField(
                  isObscure: true,
                  labelText: "Confirm Password",
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 52),
                isButtonClicked
                    ? const LoadingButton(text: "Loading")
                    : MyButton(text: "Sign Up", onTap: _register),
                const SizedBox(height: 52),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a user? ", style: kTxtNSmall),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Login",
                          style: kTxtNSmall.copyWith(color: Colors.blue)),
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
