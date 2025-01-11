import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Token_Secure_Storage.dart';
import '../main.dart';

class DeliveredScreen extends StatefulWidget {
  const DeliveredScreen({super.key});

  @override
  State<DeliveredScreen> createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentOrders();
  }

  Future<void> _fetchCurrentOrders() async {
    // Retrieve the driver's token from secure storage
    String? token = await TokenSecureStorage.getToken();

    if (token == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Use constructImageUrl to build the URL
    final url = constructImageUrl('api/orders/driver/current');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Use the retrieved token
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _orders = data['currentOrders'];
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
          ? const Center(child: Text('No delivered orders available'))
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