import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';


class AvailableDeliverScreen extends StatefulWidget {
  const AvailableDeliverScreen({super.key});

  @override
  State<AvailableDeliverScreen> createState() => _AvailableDeliverScreenState();
}

class _AvailableDeliverScreenState extends State<AvailableDeliverScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentOrders();
  }

  Future<void> _fetchCurrentOrders() async {
    // Use constructImageUrl to build the URL
    final url = constructImageUrl('api/orders/driver/current');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer YOUR_DRIVER_TOKEN', // Replace with actual token
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _orders = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? const Center(child: Text('No orders available'))
          : ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return ListTile(
            title: Text('Order ID: ${order['id']}'),
            subtitle: Text('Status: ${order['status']}'),
            // Add more details as needed
          );
        },
      ),
    );
  }
}