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

  static String _email, _password;   // _ : means the variable is private
  LocalAuthenticationService _localAuth = LocalAuthenticationService(); // make an object from LocalAuthenticationService to access fingerprint auth
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // use GlobalKey to uniquely identify the Form and validate the inputs when state change
  final FirebaseAuth _auth = FirebaseAuth.instance;  // make an object from FirebaseAuth to access authentication methods

  /* async\await :
      make asynchronous code so the method can have a parallel execution
      *other code can run and don't have to wait for this method to execute*

     Future :
       It's the result of async function.
       It means getting a value for the function called, sometime later in the future.
   */

  Future logIn() async {

    final formState = _formKey.currentState; // get the current Form state
    if (formState.validate()) { // validate if every text field in the form doesn't contain errors
      formState.save(); // Save the entered values
      try {
        FirebaseUser user = (await _auth.signInWithEmailAndPassword( // use firebase auth function "signInWithEmailAndPassword"
                email: _email, password: _password))                // and send the email and password entered
            .user;
        if (user.isEmailVerified) { // check if the user verified his email
          await _localAuth.authenticate();  // Fingerprint Auth
          if(_localAuth.isAuthenticated){
           Toast.show("Access Approved", context, // Toast is a plugin that shows floating messages easily
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
           Navigator.push(
              context, MaterialPageRoute(builder: (context) => Hello(email: _email))); // context : is a reference to the location of a Widget within
              }}                                                                      // the tree structure of all the Widgets which are built.
        else {
          Toast.show("Please verify your email.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      } catch (e) {
        if (e.message == "The password is invalid or the user does not have a password.") { // Wrong Password
            Toast.show('Error: Password is invalid', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        else{
          print(e.message);
        }
        }
    }
  }

  // ########## User Interface ##########
  @override
  Widget build(BuildContext context) {
    return Scaffold( // widget that makes a new page
      body: SingleChildScrollView( // makes the page scrollable
        child: SafeArea( // assure that no widget go outside the page boundaries
          child: Center( // center the widgets
            child: Column( // place every child(widget) on top of each other
              children: <Widget>[
                Container( // widget contain other widget to make it easy to position
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
                SizedBox( // widget used to separate other widgets vertically(height) or horizontally(width)
                  height: 100,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    width: 300,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          // text field
                          style: TextStyle(color: Colors.white),
                          // ignore: missing_return
                          validator: (input) {
                            if (input.isEmpty) { // check if input is empty
                              return 'Please type an email';
                            }
                          },
                          onSaved: (input) => _email = input, // takes user email and store it in _email
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
                            if (input.length < 6) { // check password length
                              return 'Password must have at least 6 characters';
                            }
                          },
                          onSaved: (input) => _password = input, // takes user password and store it in _password
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
                          obscureText: true, // don't show the numbers when entered
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
                  child: Row( // place every child(widget) beside each other
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
                          Navigator.push(context, MaterialPageRoute( // go to reset password page
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
                          onPressed: logIn, // logIn()
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
                    Expanded( // widget that has flexible size depend on the screen
                      child: Container(
                        margin: const EdgeInsets.only(left: 30.0, right: 4.0),
                        child: Divider( // widget that makes a line(divider)
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
                      Navigator.push(context, // go to register page
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

