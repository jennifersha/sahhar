import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final txtcateg = TextEditingController();
  final imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Category',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create Category',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: txtcateg,
                decoration: InputDecoration(
                  labelText: 'Name of Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                /*validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null; 
                },*/
              ),
              SizedBox(height: 40),
              InkWell(
                onTap: () async {
                  ImagePicker imagePicker = ImagePicker();
                  // use the getImage method on the instance to pick an image from the gallery
                  var image =
                      await imagePicker.getImage(source: ImageSource.gallery);
                  // set the image path to the controller
                  if (image != null) {
                    imageController.text = image.path;
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
                        'Choose File',
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
                    await FirebaseFirestore.instance.collection("categories")
                        // .doc(auth.currentUser!.uid.toString())
                        .add({
                      "name": txtcateg!.text,
                    });
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
                    'Create',
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
    );
  }
}
