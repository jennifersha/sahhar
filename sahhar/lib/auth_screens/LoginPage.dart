import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahhar/main.dart';
import '../admin_app/AdminDashboard.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Resetpsw.dart';
import 'SignUp.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Map<String, dynamic> loginData = {
    'email': '',
    'password': '',
  };

  bool didclick = false;
  bool isAdmin = false;

//validation
  bool validateInputs() {
    if (loginData['email'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your email',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF7E0000),
        ),
      );
      return false;
    }
    if (loginData['password'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please enter your password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7E0000),
      ));
      return false;
    }
    return true;
  }

  Future<void> signwith(String email, String pass) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //try
    try {
      if (email == 'admin@gmail.com' && pass == 'admin123') {
        // Ignore authentication for admin user
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );

        // Check if the user account is deleted (from admin)
        if (userCredential.user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User account is deleted'),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF7E0000),
            ),
          );
          return;
        }

        // Redirect to the appropriate screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SahharApp(
                    index: 0,
                  )),
        );
      }
    } //catch errors
    on FirebaseAuthException catch (e) {
      //regarding to firebase auth
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User account is deleted'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF7E0000),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email or password is incorrect'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF7E0000),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  bool checkdata() {
    if (loginData['email'].isEmpty || loginData['password'].isEmpty) {
      return false;
    }
    return true;
  }

//login with google
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

//function to login with google
  Future<String?> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return 'No user Found';
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'phoneNumber': '',
        "pass": '',
        "Firstname": user?.displayName,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'Lastname': '',
        "email": user!.email,
      });
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              color: const Color(0xFF7E0000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 10),
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 15),
                    child: Image.asset(
                      'assets/logo3.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFF7E0000),
              child: Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35)))),
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.70,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      loginData['email'] = value;
                    },
                    cursorColor: const Color(0xFF7E0000),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 25,
                        color: Color(0xFF7E0000),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF7E0000),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelStyle: const TextStyle(
                        color: Color(0xFF7E0000),
                      ),
                      labelText: "Your Email",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      loginData['password'] = value;
                    },
                    cursorColor: const Color(0xFF7E0000),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color(0xFF7E0000),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 25,
                        color: Color(0xFF7E0000),
                      ),
                      labelText: "Password",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF7E0000),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 35),
                  didclick == false
                      ? const SizedBox(
                          height: 10,
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Invalid Username or password',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  Container(
                    child: InkWell(
                      onTap: () {
                        //to insure that inputs are validate
                        // if false returned= validate
                        if (!validateInputs()) return;
                        signwith(loginData['email'], loginData['password']);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Resetpsw()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          child: Image.asset(
                            'assets/google.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        //go to googleLogin function
                        onTap: () => googleLogin().then(
                          (value) async {
                            if (value != null) {
                              //stop execution=exit
                              return;
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SahharApp(
                                          index: 0,
                                        )),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: const Text(
                      "Don’t have account? Sign up now.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
