import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'dart:io'; // Sleep
import 'Root.dart';
// https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5

class LoginScreen extends StatefulWidget {
  final FirebaseAuth _auth; // Pass down the _auth object.
  LoginScreen(this._auth);
  @override 
  State<StatefulWidget> createState() => LoginScreenState(this._auth);
}

class LoginScreenState extends State<LoginScreen> { 
  final FirebaseAuth _auth; // Pass down the _auth object.
  String _email; // User email. Maintained by state,
  String _password; // User password. Maintained by state.
  bool _register = false; // Keep track of whether to statefully show the log in or register screen
  bool _isLoading = false;
  LoginScreenState(this._auth);
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Builder(
        builder: (BuildContext context) {
            return buildTheForm(context);
        }
      )
    );
  }


  Widget buildTheForm(BuildContext context) {
    if(_isLoading)
      return Center(
        child: CircularProgressIndicator()
      );
    else if(_register) 
      return showRegisterForm(context);
    else 
      return showLoginForm(context);
  }

  Widget showRegisterForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey, // Why do we need a key here?
        // Pretty sure this is so the state of the 
        // form is preserved every time this widget is built.
        child: ListView(
          children: <Widget>[
            Image.asset("assets/eewhite.png", height: 150),
            emailInput(),
            passwordInput(),
            registerButton(context),
            returnToLogin()
          ]
        )
      )
    );
  }

    Widget registerButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 45.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(30.0)),
            child: Text(
                "Register",
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () { createAnAccount(context); },
          ),
        ));
  }



  Widget returnToLogin() {
    return InkWell(
      onTap: () { 
        this.setState(() {
          _register = false;
          }
        );
      },
      child: Text("Log in with an existing account")
    );
  }

  Widget newUser() {
    return InkWell(
      onTap: () { 
        this.setState(() {
          _register = true;
          }
        );
      },
      child: Text("Create a new account")
    );
  }

  Widget showLoginForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Image.asset("assets/eewhite.png", height: 150),
            emailInput(),
            passwordInput(),
            loginButton(context),
            newUser()
          ]
        )
      )
    );
  }


  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        key: Key("emailInput"),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Email'
        ),
        validator: (v) => v.isEmpty ? 'Empty email' : null,
        onSaved: (v) => _email = v.trim(),
      )
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0), 
      child: TextFormField( 
        key: Key("passwordInput"),
        maxLines: 1,
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password'
        ),
        validator: (v) => v.isEmpty ? 'Empty password' : null,
        onSaved: (v) => _password = v.trim(),  
      )
    );
  }

  Widget loginButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 45.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            key: Key("loginButton"),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(30.0)),
            child: Text(
                "Log In",
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              validate(context);
            }),
          ),
        );
  }

  void validate(BuildContext context) { 
    if(_formKey.currentState.validate() == false) { // Validate the fields
      return;
    }
    _formKey.currentState.save(); // Save the fields
    // API Log in
    login(InheritRootState.of(context), _email, _password);
    
  }

  void createAnAccount(BuildContext context) async {
    
    setState(() {
      _isLoading = true;
    });

    if(_formKey.currentState.validate() == false) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState.save();
    try { 
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _password)).user;
      //print(_email);  
      //print(_password);
      // Use the setData api call to create a Database table for the user.
      // Then initialize their data fields.
      Firestore.instance.collection("user").document(user.uid.toString()).setData( {
          "shoppingList": List<Map>(),
          "myKitchen": List<Map>(),
          "favoriteRecipes": List<Map>()
        }
      );

      setState(() {
        _isLoading = false;
      });

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("User $_email successfully registered.")
      ));
      sleep(const Duration(seconds: 5)); // Sleep for 2 seconds before changing state/redirecting to new screen.
      login(context.findAncestorStateOfType<RootState>(), _email, _password);

    } catch(signupError) {
      print("Error:" + signupError.toString());
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("That email address is already in use!")
        )
      );
      return;
    }
  }

}




