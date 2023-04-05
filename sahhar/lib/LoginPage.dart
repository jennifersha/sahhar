import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sahhar/globals.dart';
import 'package:sahhar/Home.dart';
import './SignUp.dart';
import './AdminDashboard.dart';
import './Resetpsw.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController? txtuser;
  TextEditingController? txtpass;
  bool didclick = false;

  bool validateInputs() {
    if (txtuser!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your email',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF7E0000),
        ),
      );
      return false;
    }
    if (txtpass!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtuser = new TextEditingController();
    txtpass = new TextEditingController();
  }

  Future<void> signwith(String email, String pass) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      DocumentSnapshot usr = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      Globals.appuser.name =
          usr['Firstname']!.toString() + ' ' + usr['Lastname']!.toString();
      Globals.appuser.password = usr['pass']!.toString();
      Globals.appuser.email = usr['email']!.toString();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email or password is incorrect',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF7E0000),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  bool checkdata() {
    if (txtuser!.text.isEmpty || txtpass!.text.isEmpty) {
      return false;
    }
    return true;
  }

//login with google
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Navigate to the home screen
      } else {
        // Handle login failure
      }
    } catch (e) {
      // Handle login failure
    }
  }

  //login with facebook
  Future<void> loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final AuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to the home screen
    } else {
      // Handle login failure
    }
  }

  //login with twitter
  /*final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: '<your_consumer_key>',
    consumerSecret: '<your_consumer_secret>',
  );

  Future<void> loginWithTwitter() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    if (result.status == TwitterLoginStatus.loggedIn) {
      final AuthCredential credential = TwitterAuthProvider.credential(
        accessToken: result.session!.token,
        secret: result.session!.secret,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to the home screen
    } else {
      // Handle login failure
    }
  }*/

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
                    height: 20,
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
                        setState(() {});
                      },
                      controller: txtuser,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          size: 25,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: "Your Email",
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (x) {
                        setState(() {});
                      },
                      controller: txtpass,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          size: 25,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
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
                          if (!validateInputs()) return;
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Resetpsw()),
                        );
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
                        GestureDetector(
                          onTap: () => loginWithFacebook(),
                          child: Container(
                            child: Image.asset(
                              'assets/facebook.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () => loginWithGoogle(),
                          child: Container(
                            child: Image.asset(
                              'assets/google.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          //onTap: () => loginWithTwitter(),
                          child: Container(
                            child: Image.asset(
                              'assets/twitter.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
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
