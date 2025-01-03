import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

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
      final response = await http.get(Uri.parse(constructImageUrl('api/products')));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          products = jsonData['data'];
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
      final response = await http.get(Uri.parse(constructImageUrl('api/stores')));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          stores = jsonData['data'];
        });
      } else {
        print('Failed to fetch stores');
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(
                          constructImageUrl(stores[index]['image'] ?? ''),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          stores[index]['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
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
                return Card(
                  child: Column(
                    children: [
                      Image.network(
                        constructImageUrl(products[index]['image'] ?? ''),
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        products[index]['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
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
