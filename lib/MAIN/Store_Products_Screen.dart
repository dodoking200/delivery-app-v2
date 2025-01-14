import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import '../APP_SCREENS/Product_Page_Screen.dart';

class StoreProductsScreen extends StatefulWidget {
  final int storeId;
  final String storeName;
  const StoreProductsScreen({super.key, required this.storeId, required this.storeName});

  @override
  State<StoreProductsScreen> createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStoreProducts();
  }

  Future<void> fetchStoreProducts() async {
    try {
      final response = await http.get(Uri.parse(constructImageUrl('api/store/products/${widget.storeId}')));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          products = jsonData['storeProducts'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch store products');
      }
    } catch (e) {
      print('Error fetching store products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName),
        backgroundColor: Colors.yellow,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.green[200], // Set background color to green
              borderRadius: BorderRadius.circular(12), // Add rounded edges
            ),
            padding: EdgeInsets.all(8), // Add padding
            margin: EdgeInsets.symmetric(vertical: 4), // Optional: Add margin between items
            child: Row(
              children: [
                // Leading widget (1/3 of the ListTile width)
                Expanded(
                  flex: 1, // 1 part for the leading widget
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Rounded edges for the image
                    child: Image.network(
                      constructImageUrlWithoutSlash(product['image']),
                      fit: BoxFit.cover, // Ensure the image covers the space
                      height: 100, // Set a fixed height for the image
                    ),
                  ),
                ),
                SizedBox(width: 8), // Add spacing between leading and content
                // Title and subtitle (2/3 of the ListTile width)
                Expanded(
                  flex: 2, // 2 parts for the title and subtitle
                  child: ListTile(
                    contentPadding: EdgeInsets.zero, // Remove default ListTile padding
                    title: Text(product['name']),
                    subtitle: Text(product['description']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPageScreen(productId: product['id']),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}