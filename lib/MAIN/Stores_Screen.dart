import 'package:flutter/material.dart';
import 'package:test1/APP_SCREENS/Product_Page_Screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';

class storesScreen extends StatefulWidget {
  const storesScreen({super.key});

  @override
  State<storesScreen> createState() => _storesScreenState();
}

class _storesScreenState extends State<storesScreen> {
  List<dynamic> stores = [];
  List<Widget> sma = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(constructImageUrl('api/stores')));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          stores = jsonData['data'];
          populateSma(); // Populate the sma list after fetching data
        });
      } else {
        print('Failed to fetch products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void populateSma() {
    sma.clear();
    for (int i = 1; i < stores.length; i += 2) {
      sma.add(
        ShowTwoBoxes(
          name1: stores[i - 1]['name'],
          image1: constructImageUrl(stores[i - 1]['image']),
          name2: stores[i]['name'],
          image2: constructImageUrl(stores[i]['image']),
        ),
      );
    }
    if (stores.length.isOdd) {
      sma.add(
        ShowTwoBoxes(
          name1: stores[stores.length - 1]['name'],
          image1: constructImageUrl(stores[stores.length - 1]['image']),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: sma.isNotEmpty
          ? sma
          : [
        const Center(
          child: CircularProgressIndicator(),
        ),
      ], // Show a loading spinner until data is loaded
    );
  }
}

class ShowBox extends StatelessWidget {
  final String? name;
  final String? image;

  const ShowBox({super.key, this.name, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProductPageScreen()),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          border: Border.all(width: 1),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              image!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0,
            ),
            Container(
              width: double.infinity,
              color: const Color(0x70000000),
              child: Text(
                textAlign: TextAlign.center,
                name!,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowTwoBoxes extends StatelessWidget {
  final String? name1;
  final String? image1;
  final String? name2;
  final String? image2;

  const ShowTwoBoxes({super.key, this.name1, this.image1, this.name2, this.image2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ShowBox(
              name: name1,
              image: image1,
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            flex: 1,
            child: name2 != null && image2 != null
                ? ShowBox(
              name: name2,
              image: image2,
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
