import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/functions/UIHelpers.dart';

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
  LoginScreenState(this._auth);   
  String _email; // User email. Maintained by state,
  String _password; // User password. Maintained by state.
  bool _register = false; // Keep track of whether to statefully show the log in or register screen

  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In")
      ),
      body: theForm(context)
    );
  }
 
  Widget theForm(context) {
    if(_register) 
      return showRegisterForm();
    else 
      return showLoginForm(context);
  }

  Widget showRegisterForm() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey, // Why do we need a key here?
        // Pretty sure this is so the state of the 
        // form is preserved every time this widget is built.
        child: ListView(
          children: <Widget>[
            emailInput(),
            passwordInput(),
            registerButton(),
            returnToLogin()
          ]
        )
      )
    );
  }

    Widget registerButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 45.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text(
                "Register",
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: createAnAccount,
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
        key: _formKey, // Why do we need a key here?
        // This is so the state of the 
        // form is preserved every time this widget is built.
        child: ListView(
          children: <Widget>[
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
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
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
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text(
                "Log In",
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              validate(context);
            }),
          ),
        );
  }

  void validate(BuildContext context) async { 
    if(_formKey.currentState.validate() == false) { // Validate the fields
      return;
    }
    _formKey.currentState.save(); // Save the fields
    // API Log in
    login(context.findAncestorStateOfType<RootState>(), _email, _password);
    
  }

  void createAnAccount() async {
    if(_formKey.currentState.validate() == false) {
      return;
    }
    _formKey.currentState.save();
    try { 
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _password)).user;
      print(_email);  
      print(_password);
      Firestore.instance.collection("user").document(user.uid.toString()).setData(
        {
          "userIngredients": List<Map>()
        }
      );
    } catch(signupError) {
      print("Error:" + signupError.toString());
      return;
    }
  }

}




