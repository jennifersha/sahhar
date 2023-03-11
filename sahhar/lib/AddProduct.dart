import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class AddProduct extends StatefulWidget {
  @override
  AddProductState createState() => AddProductState();
}

class AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  final imageController = TextEditingController();
  final txtname = TextEditingController();
  final txtprice = TextEditingController();
  final txtdescri = TextEditingController();
  final txtsize = TextEditingController();
  bool showSizes = false;
  int count = 1;
  bool switchValue = false;
  List<String> sizes = [];
  List<String> categories = [];
  List<bool> SelectedCategory = [];

  // fetch the categories data from Firebase
  Future<List<String>> fetchCategories() async {
    QuerySnapshot snapshot = await firestore.collection("categories").get();
    List<String> categories = [];
    snapshot.docs.forEach((doc) {
      categories.add(doc["name"]);
    });
    return categories;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories().then((value) {
      setState(() {
        categories = value;
        SelectedCategory = List<bool>.filled(categories.length, false);
      });
    });
    addtextfile();
  }

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //SizedBox(height: 20),
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
                SizedBox(height: 20),
                TextFormField(
                  controller: txtname,
                  decoration: InputDecoration(
                    labelText: 'Name of Product',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Name ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: txtdescri,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: lst.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Container(width: 100, child: lst[index]),
                                );
                              })),
                      Container(
                        width: 50,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF7E0000),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {
                              addtextfile();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: txtprice,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF7E0000),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            showSizes = !showSizes;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        // use the getImage method on the instance to pick an image from the gallery
                        var image = await imagePicker.getImage(
                            source: ImageSource.gallery);
                        // set the image path to the controller
                        if (image != null) {
                          imageController.text = image.path;
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: 230,
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
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF7E0000),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          /*setState(() {
                    showSizes = !showSizes;
                  });*/
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        // use the getImage method on the instance to pick an image from the gallery
                        var image = await imagePicker.getImage(
                            source: ImageSource.gallery);
                        // set the image path to the controller
                        if (image != null) {
                          imageController.text = image.path;
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: 230,
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
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF7E0000),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          /*setState(() {
                    showSizes = !showSizes;
                  });*/
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      switchValue ? 'With Text' : 'Without Text',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Switch(
                      value: switchValue,
                      onChanged: (bool value) {
                        setState(() {
                          switchValue = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: categories.map((category) {
                    int index = categories.indexOf(category);
                    return Checkbox(
                      value: SelectedCategory[index],
                      onChanged: (bool? newValue) {
                        setState(() {
                          SelectedCategory[index] = newValue ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 10),

                InkWell(
                  onTap: () async {
                    try {
                      var t = await FirebaseFirestore.instance
                          .collection("products")
                          // .doc(auth.currentUser!.uid.toString())
                          .add({
                        "name": txtname!.text,
                        "description": txtdescri!.text,
                        "size": txtsize!.text,
                        "price": txtprice!.text,
                      });

/*await FirebaseFirestore.instance.collection("categories").doc(ttt).collection("items")
                        // .doc(auth.currentUser!.uid.toString())
                        .add({
                      "name": txtname!.text,
                      "description": txtdescri!.text,
                      "size": txtsize!.text,
                      "price": txtprice!.text,
                    });*/

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
                              child: Text("Product added successfully"),
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
      ),
    );
  }

  List<Widget> lst = [];
  void addtextfile() {
    lst.add(
      TextFormField(
        controller: txtsize,
        decoration: InputDecoration(
          labelText: 'Size',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a size';
          }
          return null;
        },
        // visible: showSizes,
      ),
    );
  }
}
