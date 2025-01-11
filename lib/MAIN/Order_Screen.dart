import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../Token_Secure_Storage.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final tokenValue = await TokenSecureStorage.getToken();
      if (tokenValue == null) {
        print('Token is null');
        return;
      }

      final response = await http.get(
        Uri.parse(constructImageUrl('api/user/orders')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          orders = jsonData['orders']; // Assuming the API returns a list of orders under the key "orders"
          isLoading = false;
        });
      } else {
        print('Failed to fetch orders. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchOrderItems(int orderId) async {
    try {
      final tokenValue = await TokenSecureStorage.getToken();
      if (tokenValue == null) {
        print('Token is null');
        return;
      }

      final response = await http.get(
        Uri.parse(constructImageUrl('api/order/$orderId/items')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // Navigate to a new screen to display the order items
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderItemsScreen(orderItems: jsonData['order']['items']),
          ),
        );
      } else {
        print('Failed to fetch order items. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching order items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Column(
            children: [
              OrderItem(
                orderId: order['id'].toString(),
                status: order['status'],
                deliveryAddress: order['delivery_address'],
                bill: order['bill'],
                createdAt: order['created_at'],
                onTap: () => fetchOrderItems(order['id']), // Fetch order items when tapped
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
  final String orderId;
  final String status;
  final String deliveryAddress;
  final String bill;
  final String createdAt;
  final VoidCallback onTap;

  const OrderItem({
    required this.orderId,
    required this.status,
    required this.deliveryAddress,
    required this.bill,
    required this.createdAt,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback when the item is tapped
      child: Container(
        padding: const EdgeInsets.all(60.0),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderId',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Status: $status',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Delivery Address: $deliveryAddress',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Bill: \$$bill',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Created At: $createdAt',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemsScreen extends StatelessWidget {
  final List<dynamic> orderItems;

  const OrderItemsScreen({required this.orderItems, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Items'),
      ),
      body: ListView.builder(
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          final item = orderItems[index];
          return ListTile(
            title: Text(item['product']['name']),
            subtitle: Text('Quantity: ${item['quantity']}'),
            trailing: Text('\$${item['product']['price']}'),
          );
        },
      ),
    );
  }
}
