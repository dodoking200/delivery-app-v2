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
        'Content-Type': 'application/json',
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


  Future<void> _orderdelivered(int orderId) async {

    String? token = await TokenSecureStorage.getToken();
    final url = constructImageUrl('api/orders/status/${orderId}');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: json.encode({
        'status': 'completed',
      }),

    );

    if (response.statusCode == 200) {
      // Update the order status in the local list
      print(response.body);
      setState(() {
        final orderIndex = _orders.indexWhere((order) => order['id'] == orderId);
        if (orderIndex != -1) {
          _orders[orderIndex]['status'] = 'delivered';
        }
      });

    } else {
      print(response.statusCode);
      throw Exception('Failed to accept order');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? const Center(child: Text('No delivered orders available'))
          : GestureDetector(
        onDoubleTap: () async {
          setState(() {
            _isLoading = true; // Show loading indicator
            _orders = []; // Clear the existing orders
          });
          await _fetchCurrentOrders(); // Fetch the latest orders
        },
            child: ListView.builder(
                    padding: EdgeInsets.all(15.0),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
            final order = _orders[index];
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    color: Colors.green[100],
                  ),
                  child: ListTile(
                    title: Text('Order ID: ${order['id']}'),
                    subtitle: Text('Status: ${order['status']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        _orderdelivered(order['id']);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            );
                    },
                  ),
          ),
    );
  }
}