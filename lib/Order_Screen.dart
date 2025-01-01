import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

final List<Map<String, String>> Orders = [
  {'name': 'Product 1', 'image': 'assets/images/product3.jpg', 'count': '23'},
  {'name': 'Product 1', 'image': 'assets/images/product2.jpg', 'count': '78'},
  {'name': 'Product 1', 'image': 'assets/images/product1.jpg', 'count': '7'},
  {'name': 'Product 1', 'image': 'assets/images/product4.jpg', 'count': '1'},
  {'name': 'Product 1', 'image': 'assets/images/product5.jpg', 'count': '123'},
];
List<Widget> OrdersWidget = [];
class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {

    for (var order in Orders) {
      OrdersWidget.add(Container(
        height: 150.0,
        color: Colors.green[100],
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image(
                    image: AssetImage(order['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(child: Text(order['name']!)),
            Expanded(child: Text('Count : '+order['count']!)),
            Expanded(child: IconButton(onPressed: (){}, icon: Icon(Icons.delete)))
          ],
            mainAxisAlignment: MainAxisAlignment.center,
        ),
      ));
      OrdersWidget.add(SizedBox(height: 10.0,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: OrdersWidget,
    );
  }
}
