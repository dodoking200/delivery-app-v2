import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final List<Map<String, String>> orders = [
    {'name': 'Product 1', 'image': 'assets/images/product3.jpg', 'count': '23'},
    {'name': 'Product 2', 'image': 'assets/images/product2.jpg', 'count': '78'},
    {'name': 'Product 3', 'image': 'assets/images/product1.jpg', 'count': '7'},
    {'name': 'Product 4', 'image': 'assets/images/product4.jpg', 'count': '1'},
    {'name': 'Product 5', 'image': 'assets/images/product5.jpg', 'count': '123'},
  ];

  // Show delete confirmation dialog
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order?'),
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

  // Show edit dialog
  void _showEditDialog(int index) {
    final TextEditingController countController =
    TextEditingController(text: orders[index]['count']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Count'),
        content: TextField(
          controller: countController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter new count',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                orders[index]['count'] = countController.text;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
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
        title: const Text('cart'),
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
                      flex: 2,
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
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['name']!,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Count: ${order['count']}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => _showEditDialog(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: const Text('Edit'),
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
    );
  }
}
