import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';
import 'package:odysseusrecipes/screens/Home.dart';
import 'package:odysseusrecipes/screens/Root.dart';

void main() => runApp(OdysseusApp());

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
 
class OdysseusApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(
      title: "Odysseus Recipes",
      home: Root(),
      theme: ThemeData(
        primaryColor: Colors.blue
      )
    );
  }
}


