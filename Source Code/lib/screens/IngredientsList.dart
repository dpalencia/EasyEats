import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:odysseusrecipes/screens/SingleIngredient.dart';
import 'package:odysseusrecipes/classes/IngredientTile.dart';
import '../main.dart';

// DB Connection Based off:
// https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html
// https://pub.dev/documentation/firebase/latest/firebase_firestore/DocumentSnapshot-class.html

class IngredientsList extends StatefulWidget {
  @override 
  createState() => IngredientsListState();
}

class IngredientsListState extends State<IngredientsList> {
  Ingredient _ingredient;



  // The returned streambuilder will listen for updates 
  // to the DB and update itself with live data.
  // The streambuilder will rebuild everything beneath,
  // any time the data changes.
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      // The firestore snapshots() function
      // Handles the details of the stream implementation.
      // Stream gives us a list of 
      stream: Firestore.instance.collection('ingredients').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // In the case of ingredients, we return a 
        // ListView widget which will hold our list of ingredients.
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents); 
      }
    );
  }
  

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildIngredient(data)).toList()
    );
  }

  // Render the individual ingredient items.
  // These are:
  // ingredient.name
  // ingredient.description
  // ingredient.thumbnail
  Widget _buildIngredient(DocumentSnapshot snapshot) {
        //final Ingredient ingredient = Ingredient.fromSnapshot(data);
        return IngredientTile(setIngredient, Ingredient.fromSnapshot(snapshot)); 
  }

  void clearIngredient() {
    setState(() {
      _ingredient = null;
    });
  }

  void setIngredient(Ingredient ingredient) {
    setState( () {
      _ingredient = ingredient;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Statefully render either a single ingredient
    // Or the list of ingredients if no ingredient is defined
    // In this state object.
    if(_ingredient != null)
      return SingleIngredient(_ingredient, clearIngredient);
    else 
      return Scaffold(
        appBar: AppBar(
          title: Text("Ingredients List"),
        ),
        body: _buildBody(context)
      );
  }
}


