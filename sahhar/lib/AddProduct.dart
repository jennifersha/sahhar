import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
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
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create Product',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name of Product',
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
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                /*validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null; 
                },*/
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                /*validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null; 
                },*/
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Sizes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                /*validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a size';
                  }
                  return null; 
                },*/
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () async {
                  ImagePicker imagePicker = ImagePicker();
                  // use the getImage method on the instance to pick an image from the gallery
                  var image =
                      await imagePicker.getImage(source: ImageSource.gallery);
                  // set the image path to the controller
                  if (image != null) {
                    _imageController.text = image.path;
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 224, 224),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_file),
                      SizedBox(width: 5),
                      Text(
                        'Choose Images',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  ImagePicker imagePicker = ImagePicker();
                  // use the getImage method on the instance to pick an image from the gallery
                  var image =
                      await imagePicker.getImage(source: ImageSource.gallery);
                  // set the image path to the controller
                  if (image != null) {
                    _imageController.text = image.path;
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 226, 224, 224),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_file),
                      SizedBox(width: 5),
                      Text(
                        'Choose Colors',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  /* if (_formKey.currentState.validate()) {
                    // submit the form
                  }*/
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Color(0xFF7E0000),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'CREATE',
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
