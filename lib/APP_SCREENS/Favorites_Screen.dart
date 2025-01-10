import 'package:flutter/material.dart';
import '../Token_Secure_Storage.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<dynamic> favorites = [];

  Future<void> fetchData() async {
    try {
      final tokenValue = await token();
      if (tokenValue == null) {
        print('Token is null');
        return;
      }

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
          favorites = jsonData; // The API returns a list of products directly
        });
        print('Favorites: ${response.body}');
      } else {
        print('Failed to fetch favorites. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  Future<void> deleteFavorite(int productId) async {
    try {
      final tokenValue = await token();
      if (tokenValue == null) {
        print('Token is null');
        return;
      }

      final response = await http.post(
        Uri.parse(constructImageUrl('api/users/unfavorite/$productId')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );

      if (response.statusCode == 200) {
        print('Product removed from favorites: $productId');
        // Refresh the favorites list after deletion
        fetchData();
      } else {
        print('Failed to remove favorite. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  Future<String?> token() async {
    TokenSecureStorage storage = TokenSecureStorage();
    String? token = await TokenSecureStorage.getToken();
    return token;
  }

  void _showDeleteDialog(int index) {
    final favorite = favorites[index];
    final productId = favorite['id']; // Get the product ID

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
            onPressed: () async {
              // Call the API to delete the favorite
              await deleteFavorite(productId);
              // Remove the item from the local list
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
                            constructImageUrlWithoutSlash(favorite['image']?.substring(4) ?? ''),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
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
      ),
    );
  }
}