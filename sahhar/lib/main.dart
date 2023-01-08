import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAHHAR SHOP',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sahhar Shop'),
          backgroundColor: Color.fromARGB(255, 144, 23, 15),
        ),
        // ignore: unnecessary_new
        body: new Container(
          // ignore: unnecessary_new
          child: new Column(
            children: [
              // ignore: unnecessary_new
              new Container(
                height: 350.0,
                width: 350.0,
                // ignore: unnecessary_new
                decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          "https://snack-code-uploads.s3.us-west-1.amazonaws.com/~asset/af37a5e9dea07dc58baf6c738e5d0f60",
                        ),
                        fit: BoxFit.cover)),
              ),
              new Container(
                child: new Text(
                  'Home decor . Arts & Crafts store . Designs . Laser engraving and cutting on wood',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Aleo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
              ),
              new Container(
                child: TouchableOpacity(
                  activeOpacity: 0.2,
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
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

//child: Image.network(
 // 'https://snack-code-uploads.s3.us-west-1.amazonaws.com/~asset/af37a5e9dea07dc58baf6c738e5d0f60'),