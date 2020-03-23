import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final logoutCallBack;

  Home(this.logoutCallBack);

  @override build(BuildContext context) {
    return RaisedButton(
      child: Text("Log Out"),
      onPressed: logoutCallBack
    );
  }
}