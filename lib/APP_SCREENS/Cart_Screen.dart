import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Token_Secure_Storage.dart';
import '../main.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    String? token = await TokenSecureStorage.getToken();
    try {
      final response = await http.get(
        Uri.parse(constructImageUrl('api/cart')),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        // print("API Response: $data"); // Debugging: Print the response

        setState(() {
          cartItems = List<Map<String, dynamic>>.from(data['items']);
          print(cartItems);
          totalPrice = calculateTotalPrice(cartItems);
        });
      } else {
        print("Failed to load cart items. Status Code: ${response.statusCode}");
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print(e);
    }
  }

  double calculateTotalPrice(List<Map<String, dynamic>> items) {
    return items.fold(0.0, (sum, item) {
      final product = item['product'];
      final price =
          double.parse(product['price'].toString()); // Convert price to double
      final quantity = item['quantity'];
      return sum + (price * quantity);
    });
  }

  Future<void> deleteItem(String productId) async {
    String? token = await TokenSecureStorage.getToken();
    final response = await http.delete(
      Uri.parse(constructImageUrl('api/cart/remove')),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'product_id': productId}),
    );

    if (response.statusCode == 200) {
      fetchCartItems();
    } else {
      throw Exception('Failed to delete item');
    }
  }

  Future<void> deleteAllItems() async {
    String? token = await TokenSecureStorage.getToken();
    final response = await http.delete(
      Uri.parse(constructImageUrl('api/cart/remove/all')),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      fetchCartItems();
    } else {
      throw Exception('Failed to delete all items');
    }
  }

  Future<void> buyCartItems() async {
    String? token = await TokenSecureStorage.getToken();
    final response = await http.post(
      Uri.parse(constructImageUrl('api/cart/buy')),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      fetchCartItems();
    } else {
      throw Exception('Failed to buy cart items');
    }
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              deleteItem(cartItems[index]['product_id'].toString());
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Items'),
        content: const Text('Are you sure you want to delete all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              deleteAllItems();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _showBuyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buy Items'),
        content:
            const Text('Are you sure you want to buy all items in the cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              buyCartItems();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Cart'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _showDeleteAllDialog,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_checkout),
            onPressed: _showBuyDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text("Your cart is empty")) // Fallback UI
                : ListView.builder(
                    padding: EdgeInsets.all(15.0),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final product =
                          item['product']; // Access the product object
                      return Column(
                        children: [
                          Container(
                            height: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(14.0)),
                              color: Colors.green[100],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Container(
                                      width: 80.0,
                                      height: 80.0,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: Image.network(
                                        product['image'],
                                        // Use product['image'] instead of product['image_url']
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'], // Use product['name']
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Quantity: ${item['quantity']}',
                                        // Use item['quantity']
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'Price: \$${product['price']}',
                                        // Use product['price']
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    onPressed: () => _showDeleteDialog(index),
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
