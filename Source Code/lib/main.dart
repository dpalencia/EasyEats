import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';
import 'package:odysseusrecipes/screens/Root.dart';



void main() => runApp(OdysseusApp());
 
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


