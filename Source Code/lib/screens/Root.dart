import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';
import 'package:odysseusrecipes/screens/Home.dart';


class Root extends StatefulWidget {
  Root(this._auth);
  final FirebaseAuth _auth;
  State<StatefulWidget> createState() => RootState();
}

class RootState extends State<Root> {
  FirebaseUser _user;
  @override build(BuildContext context) {
    if(_user == null) {
      return LoginScreen(widget._auth, loginCallBack);
    } else {
      return Home(logoutCallBack);
    }
  }

  @override 
  void initState() {
    super.initState();
    awaitUser();
  }

  void awaitUser() async {
    _user = await widget._auth.currentUser();
  } 

  void loginCallBack() async {
    // Use the auth object to get the current user. Update state.
    FirebaseUser user = await widget._auth.currentUser();
    setState(() { 
          _user = user;
        }
      );
  }

  void logoutCallBack() {
    widget._auth.signOut();
    setState(() { _user = null; });
  }

}

