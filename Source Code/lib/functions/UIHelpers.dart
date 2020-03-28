
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/screens/Root.dart';
import 'package:odysseusrecipes/screens/LoginScreen.dart';

Drawer mainDrawer(RootState rootState) {
  return Drawer(
    child: ListView(
      children: <Widget> [
      ListTile(
        title: Text("Landing")
      ),
      ListTile(
        title: Text("Log Out"),
        onTap: () {
          logOut(rootState);
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