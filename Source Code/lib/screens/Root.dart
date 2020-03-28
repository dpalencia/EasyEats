import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';
import 'package:odysseusrecipes/screens/Home.dart';


class Root extends StatefulWidget {
  Root(this._auth);
  final FirebaseAuth _auth;
  State<StatefulWidget> createState() => RootState();

  FirebaseAuth getAuth() {
    return _auth; 
  }
}

class RootState extends State<Root> {
  FirebaseUser _user;
  @override build(BuildContext context) {
    if(_user == null) {
      return LoginScreen(widget._auth);
    } else {
      return Home(logoutCallBack);
    }
  }

  @override 
  void initState() {
    super.initState();
    awaitUser();
  }

  void setUser(FirebaseUser user) {
    setState(() {
        _user = user;
      }
    );
  }

  void clearUser() {
    setState(() {
      _user = null;
      }
    );
  }

  void awaitUser() async {
    _user = await widget._auth.currentUser();
  } 



  void logoutCallBack() {
    widget._auth.signOut();
    setState(() { _user = null; });
  }

}

