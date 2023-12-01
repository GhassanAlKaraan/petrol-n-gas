import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrol_n_gas/components/my_button.dart';
import 'package:petrol_n_gas/pages/auth/auth_gate.dart';
import 'package:petrol_n_gas/utility/utils.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // big logo
            Padding(
              padding: const EdgeInsets.only(
                left: 100.0,
                right: 100.0,
                top: 80,
                bottom: 20,
              ),
              child: Image.asset('assets/images/gas-pump.png'),
            ),

            // we deliver groceries at your doorstep
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                'We deliver petrol at your doorstep',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerif(
                    fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),

            // groceree gives you fresh vegetables and fruits
            Text(
              'Free delivery everyday',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            //const SizedBox(height: 24),

            const Spacer(),

            // get started button
            MyButton(text: "Get Started", onTap: () => Utility.launchPage(context, AuthGate())),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
