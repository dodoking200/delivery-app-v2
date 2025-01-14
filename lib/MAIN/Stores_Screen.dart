import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import 'Store_Products_Screen.dart';

class storesScreen extends StatefulWidget {
  final String searchQuery;

  const storesScreen({super.key, required this.searchQuery});

  @override
  State<storesScreen> createState() => _storesScreenState();
}

class _storesScreenState extends State<storesScreen> {
  List<dynamic> stores = [];
  List<Widget> sma = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true; // Flag to indicate if more stores are available

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(storesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      // Reset state when search query changes
      setState(() {
        currentPage = 1;
        stores.clear();
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
          ? constructImageUrl('api/stores/search/${widget.searchQuery}?page=$currentPage')
          : constructImageUrl('api/stores?page=$currentPage');

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> newStores = widget.searchQuery.isNotEmpty
            ? jsonData['Stores']['data']
            : jsonData['data'];
        final int lastPage = widget.searchQuery.isNotEmpty
            ? jsonData['Stores']['last_page']
            : jsonData['last_page'];

        setState(() {
          currentPage++;
          stores.addAll(newStores);
          populateSma(newStores);
          hasMore = currentPage <= lastPage; // Update hasMore flag
        });
      } else {
        print('Failed to fetch stores: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stores: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void populateSma(List<dynamic> newStores) {
    for (int i = 1; i < newStores.length; i += 2) {
      sma.add(
        ShowTwoBoxes(
          name1: newStores[i - 1]['name'],
          image1: constructImageUrl(newStores[i - 1]['image']),
          id1: newStores[i - 1]['id'],
          name2: newStores[i]['name'],
          image2: constructImageUrl(newStores[i]['image']),
          id2: newStores[i]['id'],
        ),
      );
    }

    if (newStores.length.isOdd) {
      sma.add(
        ShowTwoBoxes(
          name1: newStores.last['name'],
          image1: constructImageUrlWithoutSlash(newStores.last['image']),
          id1: newStores.last['id'],
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

class ShowBox extends StatelessWidget {
  final String? name;
  final String? image;
  final int? id;

  const ShowBox({super.key, this.name, this.image, this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreProductsScreen(storeId: id!,storeName: name!,),
            ),
          );
        }
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

class ShowTwoBoxes extends StatelessWidget {
  final String? name1;
  final String? image1;
  final String? name2;
  final String? image2;
  final int? id1;
  final int? id2;

  const ShowTwoBoxes({super.key, this.name1, this.image1, this.name2, this.image2, this.id1, this.id2});

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
              id: id1,
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
              id: id2,
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}