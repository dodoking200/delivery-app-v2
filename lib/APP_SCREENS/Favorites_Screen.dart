import 'package:flutter/material.dart';

import '../Token_Secure_Storage.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final headers = {
  'Content-Type': 'application/json',
  // Ensures you're sending JSON
  'Authorization': 'Bearer ${token()}',
  // Replace with your actual token
};

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

Future<String?> token() async {
  TokenSecureStorage storage = TokenSecureStorage();

  String? token = await TokenSecureStorage.getToken();
  return token;
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<dynamic> favorites = [];

  Future<void> fetchData() async {
    try {
      final tokenValue = await token();
      final response = await http.post(
        Uri.parse(constructImageUrl('api/users/favorites')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
            favorites = jsonData['products'] ?? [];

        });
        print(response.body);
      } else {
        print('Failed to fetch products. Status code: ${response.statusCode}');

      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }


  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Favorite'),
        content: const Text(
            'Are you sure you want to remove this item from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                favorites.removeAt(index);
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
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];

          return Column(
            children: [
              Container(
                height: 150.0,
                color: Colors.green[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display product image
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: Image.network(
                            constructImageUrlWithoutSlash(favorite['image'] ?? ''),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),
                    // Display product name and price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            favorite['name'] ?? 'Unknown Product',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${favorite['price'] ?? '0'}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Delete button
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
      )
      ,
    );
  }
}
