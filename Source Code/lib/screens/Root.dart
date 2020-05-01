import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';
import 'LandingScreen.dart';

class InheritRootState extends InheritedWidget {
  // Daniel:
  // This widget will pass down the state of the root widget.
  // https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html

  // This inherited widget serves as a wrapper for our main "Root" state.
  // Its purpose is to make it easy to climb back up the widget tree from anywhere in the app,
  // And access our user and their associated data, which is an app-wide state.
  final RootState state;

  InheritRootState({
    this.state,
    child
  }): 
  super(child: child);  // Use Widget constructor fields (inherited from Widget class)

  static RootState of(BuildContext context) {
    // Somewhere down in the widget tree,
    // The context will be passed in here to get the
    // Root State.
    return context.dependOnInheritedWidgetOfExactType<InheritRootState>().state;
  }
  @override 
  bool updateShouldNotify(InheritRootState oldWidget) {
    // Any time the root state is updated,
    // This must be reflected in all locations
    // Where this inherited widget is available.
    return oldWidget.state != state;
  }
}

class Root extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  State<StatefulWidget> createState() => RootState();

  FirebaseAuth getAuth() {
    return _auth; 
  }
}

class RootState extends State<Root> {
  // User data fields; app user model
  FirebaseUser _user;

  // Build by wrapping the state in the inherited widget.
  @override build(BuildContext context) {
    return InheritRootState(
      state: this,
      child: initialScreen()
    );
  }

  // Conditionally show login or landing if a user is logged in or out.
  Widget initialScreen() {
    if(_user == null) {
      return LoginScreen(widget._auth);
    } else {
      return LandingScreen();
    }
  }

  FirebaseUser getUser() {
    return _user;
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
