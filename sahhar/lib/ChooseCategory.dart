import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sahhar/AdminDashboard.dart';

void main() => runApp(const Categories());

class Categories extends StatelessWidget {
  const Categories();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget();

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> widgetOptions = <Widget>[
    Column(
      children: [
        Container(
          color: Color.fromARGB(255, 206, 205, 205),
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
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      color: Color.fromARGB(255, 206, 205, 203),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              doc['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                        ],
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
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: selectedIndex == 0
          ? widgetOptions.elementAt(selectedIndex)
          : Center(child: widgetOptions.elementAt(selectedIndex)),
    );
  }
}
