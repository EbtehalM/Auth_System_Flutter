import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/pages/HomePage.dart';
import 'package:toast/toast.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future resetPassword(String email) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await _auth.sendPasswordResetEmail(email: email); // use Firebase auth function "sendPasswordResetEmail" to send a password reset email
        Toast.show("Done! Check your email.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        Navigator.push( // go to HomePage (to login)
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print(e.message);
      }
    }
  }

  // ########## User Interface ##########
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 150.0),
                    child: Text(
                      'Enter email to reset password',
                      style: TextStyle(
                        color: Color(0xFF8a8b98),
                        fontSize: 22,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      width: 300,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please type an email';
                              }
                            },
                            onSaved: (input) => _email = input,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Color(0xFF8a8b98)),
                              filled: true,
                              fillColor: Color(0xFF161824),
                              prefixIcon: Container(
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    color: Color(0xFF2f3857),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0))),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                  top: 1, bottom: 1),
                              border: UnderlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: RaisedButton(
                              onPressed: () {
                                resetPassword(_email);
                              },
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Opensans',
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
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
