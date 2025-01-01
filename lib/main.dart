import 'package:flutter/material.dart';
import 'package:test1/login_screen.dart';
import 'package:test1/main_screen.dart';

import 'Product_Page_Screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}


