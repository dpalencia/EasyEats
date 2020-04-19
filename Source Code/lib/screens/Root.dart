import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';
import 'package:odysseusrecipes/screens/Home.dart';
import '../main.dart';

class InheritRootState extends InheritedWidget {
  // This widget will pass down the state of the root widget.
  // https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
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

  FirebaseUser _user;

  @override build(BuildContext context) {
    return InheritRootState(
      state: this,
      child: initialScreen()
    );
  }

  Widget initialScreen() {
    if(_user == null) {
      return LoginScreen(widget._auth);
    } else {
      return Home();
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
