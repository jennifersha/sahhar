import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController? txtfirst;
  TextEditingController? txtlast;
  TextEditingController? txtemail;
  TextEditingController? txtpass;
  TextEditingController? txtpassC;
  bool didclick = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtfirst = new TextEditingController();
    txtlast = new TextEditingController();
    txtemail = new TextEditingController();
    txtpass = new TextEditingController();
    txtpassC = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: Color(0xFF7E0000),
                  border: Border.all(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(top: 18, left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '←  Back',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            Container(
              height: 150,
              color: Color(0xFF7E0000),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 46, left: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Color(0xFF7E0000),
              child: Container(
                  width: double.infinity,
                  height: 25,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35)))),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: txtfirst,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        size: 25,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: "First Name",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: txtlast,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        size: 25,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: "Last Name",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: txtemail,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        size: 25,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: txtpass,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 25,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: "Password",
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: txtpassC,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 25,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: "Confirm Password",
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 35),
                  Container(
                    child: InkWell(
                      onTap: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        try {
                          await auth.createUserWithEmailAndPassword(
                              email: txtemail!.text, password: txtpass!.text);
                          print(auth.currentUser!.uid.toString());

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(auth.currentUser!.uid.toString())
                              .set({
                            "Firstname": txtfirst!.text,
                            "Lastname": txtlast!.text,
                            "email": txtemail!.text,
                            "pass": txtpass!.text,
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
                                  child: Text("Sign up successfully Done"),
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
                        width: 170,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
