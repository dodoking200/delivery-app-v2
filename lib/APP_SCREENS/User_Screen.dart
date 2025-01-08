import 'package:flutter/material.dart';
import 'package:test1/LOGIN/login_screen.dart';

import '../Token_Secure_Storage.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}



class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic>? userData;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    userData = await TokenSecureStorage.getUserData();
    setState(() {}); // Refresh the UI with the loaded data
  }

  void removetoken() async {
    await TokenSecureStorage.removeToken();
    await TokenSecureStorage.removeUserData();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'User Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (userData != null) ...[
                Text(
                  'First Name: ${userData!['first_name']}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Last Name: ${userData!['last_name']}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Location: ${userData!['location']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ] else ...[
                const CircularProgressIndicator(),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  print("***********************************************************");
                  removetoken();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
