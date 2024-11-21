import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCDhwVtb0gxDTOrBfBVC2WnvfLq9tkTS7k",
        appId: "1:806347000631:android:0be86a5caa8e41a7afa8b2",
        messagingSenderId: "806347000631",//project_number
        projectId: "fooddelivery-d6e32",
        storageBucket: "fooddelivery-d6e32.firebasestorage.app"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Or any page you choose
    );
  }
}
