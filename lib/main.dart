import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petrol_n_gas/firebase_options.dart';
import 'package:petrol_n_gas/model/cart_model.dart';
import 'package:provider/provider.dart';
import 'pages/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MaterialApp(
        title: "PetrolNGas",
        debugShowCheckedModeBanner: false,
        home: IntroScreen(),
      ),
    );
  }
}
