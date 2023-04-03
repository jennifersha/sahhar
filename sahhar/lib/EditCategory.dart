import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditCategory extends StatefulWidget {
  final String categoryId;

  const EditCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final formKey = GlobalKey<FormState>();
  final txtcateg = TextEditingController();
  final imageController = TextEditingController();
  late File imageFile;
  //String? imageUrl;

  @override
  void initState() {
    super.initState();
    // Retrieve the category details from Firebase
    FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          txtcateg.text = docSnapshot['name'];
          imageFile = docSnapshot['image'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Category',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Edit Category',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                TextFormField(
                  controller: txtcateg,
                  decoration: InputDecoration(
                    labelText: 'Name of Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  /*validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },*/
                ),
                SizedBox(height: 60),
                InkWell(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    // use the getImage method on the instance to pick an image from the gallery
                    var image =
                        await imagePicker.getImage(source: ImageSource.gallery);
                    // set the image path to the controller
                    if (image != null) {
                      setState(() {
                        imageFile = File(image.path);
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 226, 224, 224),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_file),
                        SizedBox(width: 5),
                        Text(
                          'Choose Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 80),
                InkWell(
                  onTap: () async {
                    try {
                      // upload the image to Firebase Storage
                      String imageUrl = '';
                      if (imageFile != null) {
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('categories/${DateTime.now().toString()}');
                        await ref.putFile(imageFile);
                        imageUrl = await ref.getDownloadURL();
                      }

                      // add the category to Firestore
                      await FirebaseFirestore.instance
                          .collection("categories")
                          .doc(widget.categoryId)
                          .update({
                        'name': txtcateg.text,
                        'imageUrl': imageUrl,
                      });

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            title: Text("Success",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            content: Container(
                              width: MediaQuery.of(context).size.width * 10,
                              child: Text("Category updated successfully"),
                            ),
                            actions: <Widget>[
                              InkWell(
                                child: Text("OK ",
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
                    } catch (x) {
                      print(x.toString());
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Color(0xFF7E0000),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
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
  }
}
