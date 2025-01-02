import 'package:flutter/material.dart';

import 'Token_Secure_Storage.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});



  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}
Future<void> token() async {
  TokenSecureStorage storage = TokenSecureStorage();

  String? token = await TokenSecureStorage.getToken();
  print('Retrieved Token: $token');
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  final List<Map<String, String>> orders = [
    {'name': 'Product 1', 'image': 'assets/images/product3.jpg'},
    {'name': 'Product 2', 'image': 'assets/images/product2.jpg'},
    {'name': 'Product 3', 'image': 'assets/images/product1.jpg'},
    {'name': 'Product 4', 'image': 'assets/images/product4.jpg'},
    {'name': 'Product 5', 'image': 'assets/images/product5.jpg'},
  ];

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Favorite'),
        content: const Text('Are you sure you want to remove this item from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                orders.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    token();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Column(
            children: [
              Container(
                height: 150.0,
                color: Colors.green[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: Image(
                            image: AssetImage(order['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        order['name']!,
                        style: const TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () => _showDeleteDialog(index),
                        icon: const Icon(Icons.close),
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
    );
  }
}
