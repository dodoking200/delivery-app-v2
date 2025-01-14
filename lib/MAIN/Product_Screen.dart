import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../APP_SCREENS/Product_Page_Screen.dart';
import '../main.dart';

class ProductScreen extends StatefulWidget {
  final String searchQuery;

  const ProductScreen({super.key, required this.searchQuery});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<dynamic> products = [];
  List<Widget> sma = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true; // Flag to indicate if more products are available
  bool isInitialFetch = true; // Indicates if this is the first fetch

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(ProductScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      // Reset state when search query changes
      setState(() {
        currentPage = 1;
        products.clear();
        sma.clear();
        hasMore = true;
      });
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final String url = widget.searchQuery.isNotEmpty
          ? constructImageUrl('api/products/search/${widget.searchQuery}?page=$currentPage')
          : constructImageUrl('api/products?page=$currentPage');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Handle both cases: with and without search query
        final List<dynamic> newProducts;
        final int lastPage;

        if (widget.searchQuery.isNotEmpty) {
          // For search response (with 'products' key)
          newProducts = jsonData['products']['data'] ?? [];
          lastPage = jsonData['products']['last_page'];
        } else {
          // For initial fetch (without 'products' key)
          newProducts = jsonData['data'] ?? [];
          lastPage = jsonData['last_page'];
        }

        setState(() {
          currentPage++;
          products.addAll(newProducts);
          populateSma(newProducts);
          hasMore = currentPage <= lastPage; // Update hasMore flag
        });
      } else {
        print('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      if (!isInitialFetch) {
        await Future.delayed(const Duration(seconds: 3));
      } else {
        isInitialFetch = false;
      }

      setState(() {
        isLoading = false;
      });
    }
  }



  void populateSma(List<dynamic> newProducts) {
    for (int i = 1; i < newProducts.length; i += 2) {
      sma.add(
        ShowTwoBoxes(
          name1: newProducts[i - 1]['name'],
          image1: constructImageUrl(newProducts[i - 1]['image']),
          id1: newProducts[i - 1]['id'],
          name2: newProducts[i]['name'],
          image2: constructImageUrl(newProducts[i]['image']),
          id2: newProducts[i]['id'],
        ),
      );
    }

    if (newProducts.length.isOdd) {
      sma.add(
        ShowTwoBoxes(
          name1: newProducts.last['name'],
          image1: constructImageUrl(newProducts.last['image']),
          id1: newProducts.last['id'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: sma +
          [
            if (hasMore)
              Container(
                height: 40.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: MaterialButton(
                  onPressed: fetchData,
                  child: isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text(
                    'Show more',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 10.0),
          ],
    );
  }
}

class ShowTwoBoxes extends StatelessWidget {
  final String? name1;
  final String? image1;
  final String? name2;
  final String? image2;
  final int? id1; // Add product ID
  final int? id2; // Add product ID

  const ShowTwoBoxes({super.key, this.name1, this.image1, this.name2, this.image2, this.id1, this.id2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: ShowBox(
              name: name1,
              image: image1,
              id: id1, // Pass product ID
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: (name2 != null && image2 != null)
                ? ShowBox(
              name: name2,
              image: image2,
              id: id2, // Pass product ID
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class ShowBox extends StatelessWidget {
  final String? name;
  final String? image;
  final int? id; // Add product ID

  const ShowBox({super.key, this.name, this.image, this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail page with the product ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPageScreen(productId: id!),
          ),
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
              constructImageUrlWithoutSlash(image!),
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

