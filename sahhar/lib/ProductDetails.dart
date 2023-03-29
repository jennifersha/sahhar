import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String price;
  final String colorUrl;
  final String size;

  ProductDetails({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.colorUrl,
    required this.size,
    required this.description,
  });

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  bool isFavorite = false;
  bool isCart = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ProductDetails",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.network(
                widget.imageUrl,
                height: 350,
                width: 350,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.description,
              style: TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            SizedBox(height: 5),
            Text(
              widget.name,
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 180),
                    Text(
                      widget.price,
                      style: TextStyle(fontSize: 24, color: Color(0xFF7E0000)),
                    ),
                    SizedBox(width: 70),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Color(0xFF7E0000),
                      ),
                      onPressed: () async {
                        setState(() {
                          isFavorite = !isFavorite;
                        });

                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final productId = widget.name;
                          final productDetails = {
                            'name': widget.name,
                            'price': widget.price,
                            'imageUrl': widget.imageUrl,
                            'colorUrl': widget.colorUrl,
                            'size': widget.size,
                            'description': widget.description,
                          };

                          // Save the product information to the "likes" collection in Firebase
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('likes')
                              .doc(productId)
                              .set(productDetails);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(
                    isCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                    color: Color(0xFF7E0000),
                  ),
                  onPressed: () async {
                    setState(() {
                      isCart = !isCart;
                    });

                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final productId = widget.name;
                      final productDetails = {
                        'name': widget.name,
                        'price': widget.price,
                        'imageUrl': widget.imageUrl,
                        'colorUrl': widget.colorUrl,
                        'size': widget.size,
                        'description': widget.description,
                      };

                      // Save the product information to the "likes" collection in Firebase
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('cart')
                          .doc(productId)
                          .set(productDetails);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Color:",
              style: TextStyle(fontSize: 22),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.colorUrl),
                radius: 20,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Size:",
              style: TextStyle(fontSize: 22),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Select the product size
                  },
                  child: Text(
                    widget.size,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
