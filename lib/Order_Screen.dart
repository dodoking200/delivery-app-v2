import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<Map<String, String>> orders = [
    {'name': 'Product 1', 'image': 'assets/images/product3.jpg', 'count': '23'},
    {'name': 'Product 2', 'image': 'assets/images/product2.jpg', 'count': '78'},
    {'name': 'Product 3', 'image': 'assets/images/product1.jpg', 'count': '7'},
    {'name': 'Product 4', 'image': 'assets/images/product4.jpg', 'count': '1'},
    {'name': 'Product 5', 'image': 'assets/images/product5.jpg', 'count': '123'},
  ];

  void _showEditDialog(int index) {

    final TextEditingController countController =
    TextEditingController(text: orders[index]['count']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: countController,
              decoration: const InputDecoration(labelText: 'Count'),
              keyboardType: TextInputType.number,
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Column(
            children: [
              OrderItem(
                name: order['name']!,
                image: order['image']!,
                count: order['count']!,
                onDelete: () => _showDeleteDialog(index),
              ),
              const SizedBox(height: 10.0),
            ],
          );
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String name;
  final String image;
  final String count;
  final VoidCallback onDelete;

  const OrderItem({
    required this.name,
    required this.image,
    required this.count,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                width: 80.0,
                height: 80.0,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Count: $count',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
