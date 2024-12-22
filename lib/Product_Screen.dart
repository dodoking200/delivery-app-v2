import 'package:flutter/material.dart';

import 'Stores_Screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}
final List<Map<String, String>> products = [
  {'name': 'Product 1', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 2', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 3', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 4', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 5', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 6', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 7', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 8', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 9', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 10', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 11', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 12', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 13', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 14', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 15', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 16', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 17', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 18', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 19', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 20', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 21', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 22', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 23', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 24', 'image': 'assets/images/product3.jpg'},
  {'name': 'Product 25', 'image': 'assets/images/product3.jpg'},
  // {'name': 'Product 26', 'image': 'assets/images/product3.jpg'},
  // {'name': 'Product 27', 'image': 'assets/images/product3.jpg'},
  // {'name': 'Product 28', 'image': 'assets/images/product3.jpg'},
  // {'name': 'Product 29', 'image': 'assets/images/product3.jpg'},
];
List<Widget> sma= [];
bool isFull = sma.length == products.length?true:false;
class _ProductScreenState extends State<ProductScreen> {
  int numberOfProduct = 11;


  void initState() {
    if(sma.isEmpty){for(int i = 1 ; i < 10; i += 2){
      sma.add(
          ShowTwoBoxes(
            name1: products[i-1]['name'],
            image1: products[i-1]['image'],
            name2: products[i]['name'],
            image2: products[i]['image'],
          )
      );
    }}
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: sma + [
        !isFull?Container(
          height: 40.0,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: MaterialButton(

            child: Text(
                'Show more'
            ),
            onPressed: (){
              setState(() {
                if(products.length - numberOfProduct >= 10){
                  for(int i = numberOfProduct ; i < numberOfProduct+ 10; i += 2){
                    sma.add(
                        ShowTwoBoxes(
                          name1: products[i-1]['name'],
                          image1: products[i-1]['image'],
                          name2: products[i]['name'],
                          image2: products[i]['image'],
                        )
                    );
                  }

                }
                else if(products.length - numberOfProduct == 0){
                  isFull=true;
                }
                else{
                  for(int i = numberOfProduct ; i < products.length ; i += 2){
                    sma.add(
                        ShowTwoBoxes(
                          name1: products[i-1]['name'],
                          image1: products[i-1]['image'],
                          name2: products[i]['name'],
                          image2: products[i]['image'],
                        )
                    );
                  }
                  if(products.length.isOdd){
                    sma.add(ShowTwoBoxes(
                      name1: products[products.length -1]['name'],
                      image1: products[products.length -1]['image'],
                    ));
                  }
                  isFull=true;
                }numberOfProduct +=10;
              });
            },
          ),
        ):SizedBox(),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }
}
