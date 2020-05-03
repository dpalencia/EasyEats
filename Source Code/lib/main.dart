import 'package:flutter/material.dart';
import 'package:odysseusrecipes/screens/Root.dart';
import 'classes/Theme.dart';



void main() => runApp(OdysseusApp());
 
class OdysseusApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(
      title: "Odysseus Recipes",
      home: Root(),
      theme: darkTheme()
    );
  }
}


