import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sahhar/HomeProducts.dart';
import 'package:sahhar/LoginPage.dart';
import 'package:sahhar/Checkout.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isCart = false;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: prefer_final_fields
  static List<Widget> _widgetOptions = <Widget>[
    //Categories Page
    Column(
      children: [
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 226, 226),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
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
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("categories").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1, crossAxisCount: 2),
                itemCount: snapshot.data!.docs.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeProducts(
                            categoryName: doc['name'],
                            categoryId: doc.id,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                doc['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                  //color: Color(0xFF7E0000),
                                  // borderRadius: BorderRadius.circular(20),
                                  ),
                              child: Center(
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
    //Likes Page
    Container(
      padding: EdgeInsets.all(26),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('likes')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No likes yet.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot productDetails = snapshot.data!.docs[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        productDetails['imageUrl'],
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productDetails['name'],
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              productDetails['description'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${productDetails['price']} ₪',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7E0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          // Add to cart function
                        },
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteProduct(productDetails.id);
                        },
                        icon: Icon(
                          Icons.delete_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    ),
    //Cart Page
    Container(
      padding: EdgeInsets.all(26),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('cart')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Cart empty.'),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot productDetails =
                          snapshot.data!.docs[index];

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              productDetails['imageUrl'],
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productDetails['name'],
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    productDetails['description'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${productDetails['price']} ₪',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7E0000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              onPressed: () {
                                // Add to cart function
                              },
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteProduct2(productDetails.id);
                              },
                              icon: Icon(
                                Icons.delete_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
                SizedBox(height: 1),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Checkout()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    ),

    //Profile Page
    Column(
      children: [
        SizedBox(height: 15),
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    height: 60,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueGrey,
                            ),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${userData['Firstname']} ${userData['Lastname']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7E0000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: Text(
                      '${userData['email']}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      //openWhatsApp();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top:
                              BorderSide(width: 1, color: Colors.grey.shade300),
                          bottom:
                              BorderSide(width: 1, color: Colors.grey.shade300),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Help',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            title: Text("Sahhar Laser Cut Shop",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            content: Container(
                              width: MediaQuery.of(context).size.width * 10,
                              child: Text(
                                  "Home decor . Arts & Crafts store . Designs . Laser engraving and cutting on wood"),
                            ),
                            actions: <Widget>[
                              InkWell(
                                child: Text("OK  ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'About',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Log out the current user
                      await FirebaseAuth.instance.signOut();

                      // Navigate back to the login screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: Colors.grey.shade300),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  ];

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
          _selectedIndex == 0
              ? 'Categories'
              : _selectedIndex == 1
                  ? 'Likes'
                  : _selectedIndex == 2
                      ? 'MyCart'
                      : 'Account Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: _selectedIndex == 0
          ? _widgetOptions.elementAt(_selectedIndex)
          : Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'likes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF7E0000),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

void deleteProduct(String productId) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('likes')
      .doc(productId)
      .delete()
      .then((value) => print('Product deleted'))
      .catchError((error) => print('Error deleting product: $error'));
}

void deleteProduct2(String productId) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('cart')
      .doc(productId)
      .delete()
      .then((value) => print('Product deleted'))
      .catchError((error) => print('Error deleting product: $error'));
}
  
/*void openWhatsApp() async {
  String phoneNumber = '+972526789152'; // replace with your phone number
  String message = 'Hello!'; // replace with your message
  String url = 'https://wa.me/$phoneNumber/?text=${Uri.parse(message)}';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}*/


