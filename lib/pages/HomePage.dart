import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/pages/hello.dart';
import 'package:notes/pages/resetPassword.dart';
import 'package:notes/pages/register.dart';
import 'package:toast/toast.dart';
import 'package:notes/services/local_authentication_service.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static String _email, _password;   
  LocalAuthenticationService _localAuth = LocalAuthenticationService(); 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
  final FirebaseAuth _auth = FirebaseAuth.instance;  

  Future logIn() async {

    final formState = _formKey.currentState; 
    if (formState.validate()) { 
      formState.save(); 
      try {
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(
                email: _email, password: _password))               
            .user;
        if (user.isEmailVerified) {
          await _localAuth.authenticate(); 
          if(_localAuth.isAuthenticated){
           Toast.show("Access Approved", context, 
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
           Navigator.push(
              context, MaterialPageRoute(builder: (context) => Hello(email: _email))); 
              }}                                                                      
        else {
          Toast.show("Please verify your email.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } catch (e) {
        if (e.message == "The password is invalid or the user does not have a password.") { 
            Toast.show('Error: Password is invalid', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        else{
          print(e.message);
        }
        }
    }
  }

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
                    'Welcome Back!',
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.only(left: 60),
                  child: Row( 
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'forgot password?',
                          style: TextStyle(
                            color: Color(0xFF8a8b98),
                            fontSize: 15,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ResetPassword()));
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: RaisedButton(
                          onPressed: logIn,
                          child: Text(
                            'Login',
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
                SizedBox(
                  height: 60,
                ),
                Row(
                  children: <Widget>[
                    Expanded( 
                      child: Container(
                        margin: const EdgeInsets.only(left: 30.0, right: 4.0),
                        child: Divider( 
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5, left: 5),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Opensans',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 4.0, right: 30.0),
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => Register()));
                    },
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

