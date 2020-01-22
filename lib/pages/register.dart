import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:notes/pages/HomePage.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static String _email, _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future register() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = (await _auth.createUserWithEmailAndPassword(  // use Firebase auth function "createUserWithEmailAndPassword"
                email: _email, password: _password))                     // to create a new user in the database
            .user;
        await user.sendEmailVerification(); // Send a verification email to the user email address
        Toast.show("Done! Check your email.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        Navigator.push( //go to HomePage so the user can login
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (signUpError) {
        if (signUpError is PlatformException) {
          if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') { // check if the email entered is registered before
            Toast.show('Error: email already registered!', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }
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
                    'Create Account',
                    style: TextStyle(
                      color: Color(0xFF8a8b98),
                      fontSize: 24,
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
                                  bottomLeft: Radius.circular(10.0),
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 1, bottom: 1),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          // ignore: missing_return
                          validator: (input) {
                            if (input.length < 6) {
                              return 'Password must have at least 6 characters';
                            }
                          },
                          onSaved: (input) => _password = input,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Color(0xFF8a8b98)),
                            filled: true,
                            fillColor: Color(0xFF161824),
                            prefixIcon: Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFF2f3857),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                              ),
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 1, bottom: 1),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(
                          //30
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: RaisedButton(
                    onPressed: register,
                    child: Text(
                      'Register',
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
      ),
    );
  }
}
