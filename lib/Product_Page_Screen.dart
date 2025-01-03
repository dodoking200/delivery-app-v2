import 'package:flutter/material.dart';

final Map<String, String> Product = {
  'name': 'Product',
  'image': 'assets/images/product1.jpg',
  'description':
      'pla pla pla pla pla pla pla pla pla pla lpa pla palpalpal plapl pal pa lapl apl pal pal pala pla plap lapl aplap laplap lpal apl pal aplpa lpa lap lp alp alpa lapl pal pal pal pal pal ap lpalpla plapalp alp lapl palpa lpal palpa ',
  'quantity': '15'
};

class ProductPageScreen extends StatefulWidget {
  const ProductPageScreen({super.key});

  @override
  State<ProductPageScreen> createState() => _ProductPageScreenState();
}

int count = 1;

class _ProductPageScreenState extends State<ProductPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 30.0),
          Center(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Image(
                image: AssetImage(Product['image']!),
                fit: BoxFit.cover,
                width: 350.0,
                height: 350.0,
              ),
            ),
          ),
          Center(
            child: Text(
              Product['name']!,
              style: const TextStyle(fontSize: 40.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Product['description']!,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (count > 1) {
                          count--;
                        }
                      });
                    },
                    icon: const Icon(Icons.remove),
                    iconSize: 30.0,
                  ),
                ),
                const SizedBox(width: 30.0),
                Text(
                  'Count: $count',
                  style: const TextStyle(fontSize: 20.0),
                ),
                const SizedBox(width: 30.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (count < int.parse(Product['quantity']!)) {
                          count++;
                        }
                      });
                    },
                    icon: const Icon(Icons.add),
                    iconSize: 30.0,
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Container(
              height: 40.0,
              width: 200.0,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: MaterialButton(
                child: const Text('Buy', style: TextStyle(color: Colors.white)),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              height: 40.0,
              width: 200.0,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: MaterialButton(
                child: const Text(
                  'Add to card',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
