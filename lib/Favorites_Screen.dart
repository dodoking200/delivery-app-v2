import 'package:flutter/material.dart';

import 'Token_Secure_Storage.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  List<dynamic> favorites = [];
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(constructImageUrl('api/favorites')));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          favorites = jsonData['data'];
        });
      } else {
        print('Failed to fetch products');
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
        content: const Text('Are you sure you want to remove this item from favorites?'),
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
  Widget build(BuildContext context) {
    token();
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
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: Image.network(
                            constructImageUrl(favorite['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        favorite['name']!,
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
