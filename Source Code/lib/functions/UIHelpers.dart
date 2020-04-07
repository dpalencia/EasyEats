
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/screens/Root.dart';
import 'package:odysseusrecipes/screens/IngredientsList.dart';
import 'package:odysseusrecipes/screens/Home.dart';
import 'package:odysseusrecipes/screens/SingleDish.dart';
import 'package:firebase_auth/firebase_auth.dart';

Drawer mainDrawer(BuildContext context) {
  return Drawer(   
    child: ListView(
      children: <Widget> [
      ListTile(
        title: Text("Landing"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
        }
      ),
      ListTile(
        title: Text("DEBUG: Single Dish"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleDish()));
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
          logOut(context.findRootAncestorStateOfType<RootState>());
        }
      )
      ]
    )
  );
}

RaisedButton buttonFunction(Function f, String text) {
  return RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: Text(
                text,
                style: TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: f
  );
}

AppBar singlePageAppBar(BuildContext context, void callback()) {
  return AppBar(
            backgroundColor: Colors.orange[400],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                callback();
              }
            ),
      );
}

