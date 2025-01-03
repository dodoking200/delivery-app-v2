import 'package:flutter/material.dart';
import 'package:test1/Card_Screen.dart';
import 'package:test1/Favorites_Screen.dart';
import 'package:test1/Order_Screen.dart';
import 'package:test1/Product_Screen.dart';
import 'package:test1/Stores_Screen.dart';
import 'package:test1/User_Screen.dart';
import 'package:test1/homeScreen.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
    const HomeScreen(),
    const storesScreen(),
    const ProductScreen(),
    const OrderScreen(),
  ];
  List<String> Titles = [
    "Main page",
    "Stores page",
    "Product page",
    "Orders page",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.yellow,
        leading: _selectedIndex == 0 || _selectedIndex == 3
            ? null
            : IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {

                },
              ),
        title: Text(
          Titles[_selectedIndex],
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CardScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
          index: _selectedIndex,
          children: screens,
      ),
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
