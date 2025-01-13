import 'package:flutter/material.dart';
import '../LOGIN/login_screen.dart';
import 'Available_Deliver_Screen.dart';
import 'Delivered_Screen.dart';
import '../Token_Secure_Storage.dart';

class DMainScreen extends StatefulWidget {
  const DMainScreen({super.key});

  @override
  _DMainScreenState createState() => _DMainScreenState();
}

class _DMainScreenState extends State<DMainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    try {
      // Call the logout API
      await TokenSecureStorage.removeTokendriver();

      // Navigate to the LoginScreen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle any errors that occur during logout
      print('Error during logout: $e');
    }
  }

  List<Widget> screens = [
    AvailableDeliverScreen(),
    DeliveredScreen(),
  ];
  List<String> Titles = [
    "Available page",
    "Delivered page",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          Titles[_selectedIndex],
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _logout, // Call the logout function
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0?Icons.shopping_basket:Icons.shopping_basket_outlined, color: Colors.black),
            label: 'Available',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1?Icons.local_shipping:Icons.local_shipping_outlined, color: Colors.black),
            label: 'Delivered',
          ),
        ],
        backgroundColor: Colors.yellow,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}