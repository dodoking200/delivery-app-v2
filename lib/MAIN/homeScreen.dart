import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../APP_SCREENS/Product_Page_Screen.dart';
import '../main.dart';
import 'Store_Products_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> products = [];
  List<dynamic> stores = [];
  bool isLoading = true; // To handle loading state

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchData2();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(constructImageUrl('api/products/relevant')));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          products = jsonData['RelevantProducts'];
        });
      } else {
        print('Failed to fetch products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> fetchData2() async {
    try {
      final response = await http.get(Uri.parse(constructImageUrl('api/stores/relevant')));
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        setState(() {
          stores = jsonData['RelevantStores'];
        });
      } else {
        print('Failed to fetch stores');
        print(response.body);
      }
    } catch (e) {
      print('Error fetching stores: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Display Stores in a Horizontal List
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to StoreProductsScreen when a store is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreProductsScreen(storeId: store['id'],storeName: store['name'],),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      child: Column(
                        children: [
                          Image.network(
                            constructImageUrlWithoutSlash(store['image'] ?? ''),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            store['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Display Products in a Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to ProductPageScreen when a product is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPageScreen(productId: product['id']),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(
                          constructImageUrlWithoutSlash(product['image'] ?? ''),
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          product['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}