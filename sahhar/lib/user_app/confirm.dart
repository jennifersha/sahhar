import 'package:flutter/material.dart';
import '../main.dart';
import '../user_app/AccontInfo.dart';

class confirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirmation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: Center(
        child: Card(
          //color: Colors.grey.shade300,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Congratulations !',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const Divider(
                  color: Color(0xFF7E0000),
                  thickness: 1.5,
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'Your order is set. You will be notified\nonce your order is completed to get it from the Shop.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7E0000),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'Thank you for shopping at\nSahhar Laser.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                      alignment: Alignment.center,
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF7E0000).withOpacity(0.1)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SahharApp(
                                  index: 3,
                                )),
                      );
                    },
                    child: const Text(
                      'Go to Profile to see Order Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF7E0000),
                        //fontWeight: FontWeight.bold,
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
