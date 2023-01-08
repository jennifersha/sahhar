import 'package:flutter/material.dart';
import './SignUp.dart';
import './AdminDashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                child: Text(
                  '← back',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ),
            Container(
              height: 200,
              color: Color(0xFF7E0000),
              child: Center(
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
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      icon: Icon(Icons.person),
                      labelText: "Username Or Email",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      icon: Icon(Icons.lock),
                      labelText: "Password",
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 35),
                  Container(
                    child: InkWell(
                      onTap: () {},
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
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      // Navigate to "Forgot Password" page
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 110),
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
    );
  }
}
