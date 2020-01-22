import 'package:flutter/material.dart';

class Hello extends StatelessWidget {

  // to get the data passed in the parameter
  String email;
  Hello({Key key, this.email}) : super (key: key);


  // ########## User Interface ##########
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'Hello, $email',
            style: TextStyle(
              color: Color(0xFF8a8b98),
              fontSize: 24,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }
}
