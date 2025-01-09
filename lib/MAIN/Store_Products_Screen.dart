import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import '../APP_SCREENS/Product_Page_Screen.dart';

class StoreProductsScreen extends StatefulWidget {
  final int storeId;

  const StoreProductsScreen({super.key, required this.storeId});

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
        title: Text('Store Products'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text(product['description']),
            leading: Image.network(constructImageUrl(product['image'])),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPageScreen(productId: product['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}