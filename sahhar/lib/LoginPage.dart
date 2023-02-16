import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sahhar/globals.dart';
import 'package:sahhar/path/Home.dart';
import './SignUp.dart';
import './AdminDashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController? txtuser;
  TextEditingController? txtpass;
  bool didclick = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtuser = new TextEditingController();
    txtpass = new TextEditingController();
  }

  Future<void> signwith(String email, String pass) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: email, password: pass);
    if (auth == null) {}
    DocumentSnapshot usr = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get();
    Globals.appuser.name =
        usr['Firstname']!.toString() + ' ' + usr['Lastname']!.toString();
    Globals.appuser.password = usr['pass']!.toString();
    Globals.appuser.email = usr['email']!.toString();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  bool checkdata() {
    if (txtuser!.text.isEmpty || txtpass!.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Globals.cls,
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
                    padding: EdgeInsets.only(bottom: 20, left: 10),
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
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
                      onChanged: (x) {
                        txtuser!.text = x;
                        setState(() {});
                      },
                      controller: txtuser,
                      maxLength: 20,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          size: 25,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        labelText: "Username Or Email",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (x) {
                        txtpass!.text = x;
                        setState(() {});
                      },
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
                    SizedBox(height: 35),
                    didclick == false
                        ? SizedBox(
                            height: 10,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Invalid Username or password',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          signwith(txtuser!.text, txtpass!.text);
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
                              'LOGIN',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        // Navigate to "Forgot Password" page
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/facebook.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          child: Image.asset(
                            'assets/google.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          child: Image.asset(
                            'assets/twitter.png',
                            width: 40,
                            height: 40,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        "Don’t have account? Sign up now.",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminDashboard()),
                        );
                      },
                      child: Text(
                        "admin",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
