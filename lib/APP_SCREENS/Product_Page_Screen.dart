import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Token_Secure_Storage.dart';
import '../main.dart';

class ProductPageScreen extends StatefulWidget {
  final int productId;

  const ProductPageScreen({super.key, required this.productId});

  @override
  State<ProductPageScreen> createState() => _ProductPageScreenState();
}

class _ProductPageScreenState extends State<ProductPageScreen> {
  Map<String, dynamic> product = {};
  bool isLoading = true;
  int count = 1;

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    try {
      String url =constructImageUrl('api/product/${widget.productId}');
      final response = await http.get(
        Uri.parse( url),
      );

      if (response.statusCode == 200) {
        setState(() {
          final json_response = jsonDecode(response.body);
          product = json_response['product'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          const SizedBox(height: 30.0),
          Center(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Image.network(
                product['image'],
                fit: BoxFit.cover,
                width: 350.0,
                height: 350.0,
              ),
            ),
          ),
          Center(
            child: Text(
              product['name'],
              style: const TextStyle(fontSize: 40.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['description'],
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (count > 1) {
                          count--;
                        }
                      });
                    },
                    icon: const Icon(Icons.remove),
                    iconSize: 30.0,
                  ),
                ),
                const SizedBox(width: 30.0),
                Text(
                  'Count: $count',
                  style: const TextStyle(fontSize: 20.0),
                ),
                const SizedBox(width: 30.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {

                          count++;

                      });
                    },
                    icon: const Icon(Icons.add),
                    iconSize: 30.0,
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Container(
              height: 40.0,
              width: 200.0,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: MaterialButton(
                child: const Text('Buy', style: TextStyle(color: Colors.white)),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              height: 40.0,
              width: 200.0,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: MaterialButton(
                child: const Text(
                  'Add to cart',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  addToCart(product['id'], count);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addToCart(int productId, int quantity) async {
    final token = await TokenSecureStorage.getToken();
    if (token == null) {
      print('No token found');
      return;
    }

    final url = Uri.parse(constructImageUrl('api/cart/add'));
    final body = jsonEncode({
      'product_id': productId,
      'quantity_up': quantity,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Product added to cart');
    } else {
      print('Failed to add product to cart: ${response.statusCode}');
    }
  }
}