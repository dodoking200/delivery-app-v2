import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test1/Card_Screen.dart';
import 'package:test1/Order_Screen.dart';
import 'package:test1/Product_Screen.dart';
import 'package:test1/Stores_Screen.dart';
import 'package:test1/homeScreen.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Sample data for stores and products
  final List<Map<String, String>> stores = [
    {'name': 'Store 1', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 2', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 3', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 4', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 5', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 6', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 7', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 8', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 9', 'image': 'https://via.placeholder.com/150'},
  ];

  final List<Map<String, String>> products = [
    {'name': 'Product 1', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 2', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 3', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 4', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 5', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 6', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 7', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 8', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 9', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 10', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 11', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 12', 'image': 'https://via.placeholder.com/100'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> screens = [
    HomeScreen(),
    storesScreen(),
    ProductScreen(),
    OrderScreen(),
  ];
  List<String> Titles = [
    "Main page",
    "Stores page",
    "product page",
    "Favorites page",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF950),
        leading: _selectedIndex == 0
            ? null
            : IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {},
              ),
        title: Text(
          'Main Page',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CardScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store, color: Colors.black),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket, color: Colors.black),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping, color: Colors.black),
            label: 'Orders',
          ),
        ],
        backgroundColor: Color(0xFFFFF950),
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
