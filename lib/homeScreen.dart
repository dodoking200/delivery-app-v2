import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final List<Map<String, String>> stores = [
    {'name': 'Store 1', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 2', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 3', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 4', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 5', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 6', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 7', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 8', 'image': 'https://via.placeholder.com/150'},
    {'name': 'Store 9', 'image': 'https://via.placeholder.com/150'},
  ];

  final List<Map<String, String>> products = [
    {'name': 'Product 1', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 2', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 3', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 4', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 5', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 6', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 7', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 8', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 9', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 10', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 11', 'image': 'https://via.placeholder.com/100'},
    {'name': 'Product 12', 'image': 'https://via.placeholder.com/100'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Display Stores in a Horizontal List
          SizedBox(
            height: 150, // Set a fixed height for the horizontal list
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
                          stores[index]['image']!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 5),
                        Text(
                          stores[index]['name']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10), // Add spacing between Stores and Products
          // Display Products in a Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      // Image.network(
                      //   products[index]['image']!,
                      //   height: 70,
                      //   fit: BoxFit.cover,
                      // ),
                      SizedBox(height: 5),
                      Text(
                        products[index]['name']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
