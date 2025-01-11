import 'package:flutter/material.dart';

import 'Available_Deliver_Screen.dart';
import 'Delivered_Screen.dart';


// import 'package:http/http.dart' as http;
// import 'dart:convert';

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

  List<Widget> screens = [
    const AvailableDeliverScreen(),
    const DeliveredScreen(),
  ];
  List<String> Titles = [
    "Avalible page",
    "Delivered page",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.yellow,
        title: Text(
          Titles[_selectedIndex],
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket, color: Colors.black),
            label: 'Avalible',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping, color: Colors.black),
            label: 'Delivered',
          ),
        ],
        backgroundColor:  Colors.yellow,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        // Prevents shifting behavior
        elevation: 0,
        // Removes shadow
        selectedItemColor: Colors.black,
        // Ensure selected item remains black
        unselectedItemColor: Colors.black,
        // Ensure unselected items are black
        onTap: _onItemTapped,
      ),
    );
  }
}
