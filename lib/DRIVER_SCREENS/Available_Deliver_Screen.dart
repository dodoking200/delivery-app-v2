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
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    if (!_hasMore) return;

    final url = constructImageUrl('api/orders?page=$_currentPage');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer YOUR_DRIVER_TOKEN', // Replace with actual token
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> newOrders = data['orders']['data'];

      setState(() {
        _orders.addAll(newOrders);
        _isLoading = false;
        _hasMore = data['orders']['next_page_url'] != null;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load orders');
    }
  }

  void _loadMore() {
    if (_hasMore) {
      setState(() {
        _currentPage++;
      });
      _fetchOrders();
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
        itemCount: _orders.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _orders.length) {
            return Center(
              child: ElevatedButton(
                onPressed: _loadMore,
                child: const Text('Load More'),
              ),
            );
          }
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