import 'package:flutter/material.dart';
import 'package:test1/LOGIN/login_screen.dart';
import 'package:test1/Token_Secure_Storage.dart';

import 'DRIVER_SCREENS/DMAIN_SCREEN.dart';
import 'MAIN/main_screen.dart';

//http://192.168.237.103:8000/ is my mobile (xiamoi)


String constructImageUrl(String relativePath) {
  const baseUrl = 'http://192.168.1.109:8000/';
  return baseUrl + relativePath;
}

String constructImageUrlWithoutSlash(String relativePath) {
  const baseUrl = 'http://192.168.1.109:8000';
  return baseUrl + relativePath;
}

Future<bool> hasToken() async {
  return await TokenSecureStorage.hasToken();
}

Future<bool> isDriver() async {
  return await TokenSecureStorage.isDriver();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: hasToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            return FutureBuilder<bool>(
              future: isDriver(),
              builder: (context, driverSnapshot) {
                if (driverSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (driverSnapshot.hasData && driverSnapshot.data == true) {
                  return const DMainScreen(); // User is a driver
                } else {
                  return const MainScreen(); // User is not a driver
                }
              },
            );
          } else {
            return const LoginScreen(); // User is not authenticated
          }
        },
      ),
    );
  }
}