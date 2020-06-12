import 'package:flutter/material.dart';

class Hello extends StatelessWidget {

  String email;
  Hello({Key key, this.email}) : super (key: key);


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
