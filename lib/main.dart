import 'package:flutter/material.dart';
import 'package:test1/login_screen.dart';


String constructImageUrl(String relativePath) {
  const baseUrl = 'http://192.168.201.103:8000/';
  return baseUrl + relativePath;


}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}


