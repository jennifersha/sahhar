import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeProducts extends StatefulWidget {
  final String categoryName;

  HomeProducts({required this.categoryName});

  @override
  HomeProductsState createState() => HomeProductsState();
}

class HomeProductsState extends State<HomeProducts> {
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
      body: Center(
        child: Text('Products for ${widget.categoryName}'),
      ),
    );
  }
}
