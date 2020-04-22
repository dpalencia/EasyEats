import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/screens/DishesList.dart';
import 'package:odysseusrecipes/screens/IngredientsList.dart';
import 'package:odysseusrecipes/screens/LandingScreen.dart';
import 'package:odysseusrecipes/screens/Root.dart';
class MainDrawer extends StatelessWidget  {
  @override 
  build(BuildContext context) {
    
    return Drawer(   
    child: ListView(
      children: <Widget> [
      ListTile(
        title: Text("Landing"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LandingScreen()));
        }
      ),
      ListTile(
        title: Text("Dishes"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DishesList()));
        }
      ),
      ListTile(  
          title: Text("Ingredients List"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => IngredientsList()));
          }
      ),
      ListTile(
        title: Text("Log Out"),
        onTap: () {
          Navigator.of(context).pop();
          logOut(InheritRootState.of(context));
        }
      )
      ]
    )
  );
  }
}