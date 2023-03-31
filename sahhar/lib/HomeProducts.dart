import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sahhar/ProductDetails.dart';

class HomeProducts extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  HomeProducts({
    required this.categoryName,
    required this.categoryId,
  });

  @override
  HomeProductsState createState() => HomeProductsState();
}

class HomeProductsState extends State<HomeProducts> {
  bool isFavorite = false;
  bool isCart = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void toggleCart() {
    setState(() {
      isCart = !isCart;
    });
  }

  int _selectedIndex = 0;
  late String categoryId;

  @override
  void initState() {
    super.initState();
    categoryId = widget.categoryId;
  }

  // Moved StreamBuilder to Separate Method
  Widget buildProductGrid() {
    if (categoryId == null || categoryId.isEmpty) {
      return Center(
        child: Text("Invalid category ID."),
      );
    }

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("categories")
            .doc(categoryId != null ? categoryId : '')
            .collection("items")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1, crossAxisCount: 2),
            itemCount: snapshot.data!.docs.length,
            padding: EdgeInsets.all(12),
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          imageUrl: doc['imageUrl'],
                          name: doc['name'],
                          price: doc['price'],
                          colorUrl: doc['colorUrl'],
                          size: doc['size'],
                          description: doc['description'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 1),
                        Container(
                          height: 110,
                          width: 110,
                          child: Image.network(
                            doc['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 2),
                        /*Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 24.0),
                          child: Text(
                            doc['name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2),*/
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24.0),
                            child: Text(
                              doc['description'],
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        //SizedBox(height: 2),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 24.0),
                                child: Text(
                                  '${doc['price']} ₪',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 40),
                            Expanded(
                              child: IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Color(0xFF7E0000),
                                ),
                                onPressed: () {
                                  toggleFavorite();
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: IconButton(
                                icon: Icon(
                                  isCart
                                      ? Icons.shopping_cart
                                      : Icons.shopping_cart_outlined,
                                  color: Color(0xFF7E0000),
                                ),
                                onPressed: () {
                                  toggleCart();
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          //SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 226, 226, 226),
                borderRadius: BorderRadius.circular(30),
              ),
              /*child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.black,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search..',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),*/
            ),
          ),
          buildProductGrid(), // Call the method here
        ],
      ),
    );
  }
}
