import 'package:flutter/material.dart';

class storesScreen extends StatefulWidget {
  @override
  State<storesScreen> createState() => _storesScreenState();
}

class _storesScreenState extends State<storesScreen> {
  final List<Map<String, String>> stores = [
    {'name': 'Store 1', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 2', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 3', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 4', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 5', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 6', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 7', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 8', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 9', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 10', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 11', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 12', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 13', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 14', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 15', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 16', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 17', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 18', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 19', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 20', 'image': 'assets/images/product1.jpg'},
    {'name': 'Store 1', 'image': 'assets/images/product1.jpg'},
  ];
  List<Widget> sma= [];
  @override
  void initState() {
    for(int i = 1 ; i < stores.length; i += 2){
      sma.add(
          ShowTwoBoxes(
            name1: stores[i-1]['name'],
            image1: stores[i-1]['image'],
            name2: stores[i]['name'],
            image2: stores[i]['image'],
          )
      );
    }
    if(stores.length.isOdd){
      sma.add(ShowTwoBoxes(
        name1: stores[stores.length -1]['name'],
        image1: stores[stores.length -1]['image'],
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: sma,
    );
  }
}

class ShowBox extends StatelessWidget{
  String? name;
  String? image;
  ShowBox({this.name,this.image});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          border: Border.all(
            width: 1
          )
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image(
                image: AssetImage(image!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
            ),
            Container(

                width: double.infinity,
                color: Color(0x70000000),
                child: Text(
                  textAlign: TextAlign.center,
                    name!,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,

                  ),
                )

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

  ShowTwoBoxes({this.name1, this.image1, this.name2, this.image2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1, // Always occupies half of the screen width
          child: ShowBox(
            name: name1,
            image: image1,
          ),
        ),
        Expanded(
          flex: 1,
          child: name2 != null && image2 != null? ShowBox(
            name: name2,
            image: image2,
          )
              : SizedBox(),
        ),
      ],
    );
  }
}



