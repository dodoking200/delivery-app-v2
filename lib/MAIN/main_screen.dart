import 'package:flutter/material.dart';
import 'package:test1/APP_SCREENS/Card_Screen.dart';
import 'package:test1/APP_SCREENS/Favorites_Screen.dart';
import 'package:test1/MAIN/Order_Screen.dart';
import 'package:test1/MAIN/Product_Screen.dart';
import 'package:test1/MAIN/Stores_Screen.dart';
import 'package:test1/APP_SCREENS/User_Screen.dart';
import 'package:test1/MAIN/homeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String searchQuery = ''; // Add a search query state

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchPressed() {
    if (_selectedIndex == 1 || _selectedIndex == 2) {
      // Navigate to the search screen for stores or products
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchStoreScreen(
            onSearch: (String query) {
              setState(() {
                searchQuery = query; // Update the search query
                // Ensure the correct screen is active based on the selected index
                _selectedIndex = _selectedIndex;
              });
            },
            searchType: _selectedIndex == 1 ? 'stores' : 'products', // Pass the search type
          ),
        ),
      );
    }
  }

  // Use a getter to dynamically generate the screens list
  List<Widget> get screens => [
    const HomeScreen(),
    storesScreen(searchQuery: searchQuery), // Pass the search query to storesScreen
    ProductScreen(searchQuery: searchQuery),
    const OrderScreen(),
  ];

  final List<String> Titles = [
    "Main page",
    "Stores page",
    "Product page",
    "Orders page",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: _selectedIndex == 0 || _selectedIndex == 3
            ? null
            : IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: _onSearchPressed,
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

class SearchStoreScreen extends StatelessWidget {
  final Function(String) onSearch;
  final String searchType; // Add a searchType parameter

  const SearchStoreScreen({super.key, required this.onSearch, this.searchType = 'stores'});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: searchType == 'stores' ? 'Search stores...' : 'Search products...',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            onSearch(value); // Pass the search query back
            Navigator.of(context).pop(); // Close the search screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              onSearch(searchController.text); // Pass the search query back
              Navigator.of(context).pop(); // Close the search screen
            },
          ),
        ],
      ),
      body: Container(), // You can add search results here if needed
    );
  }
}