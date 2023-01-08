import 'package:flutter/material.dart';
import './AddCategory.dart';
import './AddProduct.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 500,
              child: Drawer(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: DrawerHeader(
                        child: Row(
                          children: [
                            Icon(Icons.supervised_user_circle),
                            SizedBox(width: 10),
                            Text(
                              'Admin Dashboard',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF7E0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF7E0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddProduct()),
                        );
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Text(
                              'Add Product',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF7E0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF7E0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCategory()),
                        );
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Text(
                              'Add Category',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF7E0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            Text(
                              'Orders Schedule',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF7E0000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
