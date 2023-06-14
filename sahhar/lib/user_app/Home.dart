import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahhar/user_app/products.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCart = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            //to bring data
            child: StreamBuilder<QuerySnapshot>(
              // data retrieved from snapshot
              stream: FirebaseFirestore.instance
                  .collection("categories")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF7E0000),
                  ));
                } else if (snapshot.data!.docs.length == 0 &&
                    snapshot.connectionState != ConnectionState.waiting) {
                  return Center(
                    child: Text(
                      'No Categories Yet',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w300),
                    ),
                  );
                } else {
                  //return the categories as:
                  return GridView.builder(
                    //take space needed
                    shrinkWrap: true,
                    //scroll through grid
                    physics: const BouncingScrollPhysics(),
                    //layout of the grid
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          MediaQuery.of(context).size.height * 0.43,
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.30,
                      childAspectRatio: 1,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    //length of the categories items(how many)
                    itemCount: snapshot.data!.docs.length,
                    padding: EdgeInsets.zero,
                    //item builder
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: GestureDetector(
                          //on tap on the image/name of category
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                //go to products page
                                builder: (context) => HomeProducts(
                                  categoryName: doc['name'],
                                  categoryId: doc.id,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        doc['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    child: Center(
                                      child: Text(
                                        doc['name'].toString().toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          overflow: TextOverflow.fade,
                                          color: Color(0xFF7E0000),
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
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
