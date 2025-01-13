import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Token_Secure_Storage.dart';
import '../main.dart';
import '../MAIN/Order_Screen.dart';

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
        'Content-Type': 'application/json',
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

  Future<void> _acceptOrder(int orderId) async {

    String? token = await TokenSecureStorage.getToken();
    final url = constructImageUrl('api/orders/accept/${orderId}');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },

    );

    if (response.statusCode == 200) {
      // Update the order status in the local list
      print(response.body);
      setState(() {
        final orderIndex = _orders.indexWhere((order) => order['id'] == orderId);
        if (orderIndex != -1) {
          _orders[orderIndex]['status'] = 'accepted';
        }
      });

    } else {
      print(response.statusCode);
      throw Exception('Failed to accept order');

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
    return GestureDetector(
      onDoubleTap: () async {
        setState(() {
          _currentPage = 1; // Reset the page to 1
          _orders = []; // Clear the existing orders
          _isLoading = true; // Set loading to true to show the loading indicator
          _hasMore = true; // Reset the hasMore flag
        });
        await _fetchOrders(); // Fetch the orders again
      },
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _orders.isEmpty
            ? const Center(child: Text('No orders available'))
            : ListView.builder(
          padding: EdgeInsets.all(15.0),
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
            return GestureDetector(
              onTap: () => fetchOrderItems(order['id']),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      color: Colors.green[100],
                    ),
                    child: ListTile(
                      title: Text('Order ID: ${order['id']}'),
                      subtitle: Text('Status: ${order['status']}'),
                      trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          icon: const Text("accept",
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _acceptOrder(order['id']);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}