import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200,
          width: double.infinity,
          child: Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("categories")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading..");
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2, crossAxisCount: 2),
                  itemCount: (snapshot.data!).docs.length,
                  padding: EdgeInsets.all(1.0),
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot doc = (snapshot.data!).docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.amber,
                        width: 50,
                        height: 50,
                        child: Text(doc['name']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      )),
    );
  }
}
