//Works as intended but is currently hard coded to print just this one picture and only
//redirects to the single dish
//TODO: Clean it up make it a little nicer
//TODO: Implement Scroll Function
//TODO: Take in dishes from the database and use that info and images in functions
//rather than hard coding

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/screens/SingleDish.dart';

//I have this for testing purposes
//change class name back to DishesList and remove main function.
/* main() => runApp(MaterialApp(
      home: Home(),
    ));*/

class DishesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dishes List"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[dishCard(context)],
      ),
    );
  }
}

Widget dishCard(BuildContext context) {
  return Center(
    child: Container(
      height: 300,
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            onTap(context);
          }, //TODO: Update onTap function to not be hardcoded
          child: Column(
            children: <Widget>[
              dishCardImage,
              dishCardText,
            ],
          ),
        ),
        elevation: 100,
        margin: EdgeInsets.all(10),
      ),
    ),
  );
}

var dishCardImage = FittedBox(
  fit: BoxFit.contain,
  child: Image.network(
      'https://firebasestorage.googleapis.com/v0/b/odysseus-recipes.appspot.com/o/Images%2FwheatBread.jpg?alt=media&token=5143ed7e-1a99-49df-9eca-cec8ab656fb0'),
  // demo, replace with get image from database for example (have to pass in values).
);
var dishCardText = Container(
  width: 300,
  height: 50,
  child: Text(
    "Wheat Bread",
    //TODO: Currently Hard Coded, need to pass in value.
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    ),
  ),
);
void onTap(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SingleDish()));
}
//TODO: Currently hard coded to go to Chris's page

class Dish {
  final String name;
  final List categories;
  //final DocumentReference reference;
  final String imageURL;

  Dish(name, description, categories, reference, url)
      : name = name,
        //reference = reference,
        categories = categories,
        imageURL = url;
  //TODO: All the database stuff. This is all currently unused
}
