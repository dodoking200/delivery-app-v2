import 'package:flutter/material.dart';
import 'package:test1/LOGIN/login_screen.dart';
import 'package:test1/Token_Secure_Storage.dart';

import 'MAIN/main_screen.dart';
//http://192.168.237.103:8000/ is my mobile (xiamoi)
String constructImageUrl(String relativePath) {
  const baseUrl = 'http://192.168.237.103:8000/';
  return baseUrl + relativePath;
}
String constructImageUrlWithoutSlash(String relativePath) {
  const baseUrl = 'http://192.168.237.103:8000';
  return baseUrl + relativePath;
}

Future<bool> hasToken() async {
  return await TokenSecureStorage.hasToken();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: hasToken(),
        builder: (context, snapshot) {
          // Check if the Future is complete
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the Future
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // If the Future is resolved
          if (snapshot.hasData && snapshot.data == true) {
            return MainScreen(); // User is authenticated
          } else {
            return LoginScreen(); // User is not authenticated
          }
        },
      ),
    );
  }
}
