import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// DB Connection Based off:
// https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html
// https://pub.dev/documentation/firebase/latest/firebase_firestore/DocumentSnapshot-class.html

class IngredientsList extends StatelessWidget {
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
      children: snapshot.map((data) => _buildIngredient(context, data)).toList()
    );
  }

  // Render the individual ingredient items.
  // These are:
  // ingredient.name
  // ingredient.description
  // ingredient.thumbnail
  Widget _buildIngredient(BuildContext context, DocumentSnapshot data) {
        final Ingredient ingredient = Ingredient.fromSnapshot(data);
        return Padding(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ingredient.imageURL)
              ),
              title: Text(ingredient.name),
            ), 
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
        ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingredients List"),
      ),
      body: _buildBody(context)
    );
  }
}


class Ingredient {
  // The fields
  final String name; 
  final String description;
  final List categories;
  final DocumentReference reference;
  final String imageURL;

  // Defining named constructors from initializer list.
  Ingredient(name, description, categories, reference, url): 
    name = name, description = description, 
    reference = reference,
    categories = categories,
    imageURL = url;

  Ingredient.fromMap(Map<String, dynamic> map, DocumentReference reference) 
    : this(map['name'], map['description'], map['categories'], reference, map['imageURL']);
  Ingredient.fromSnapshot(DocumentSnapshot snapshot) 
    : this.fromMap(snapshot.data, snapshot.reference);
  @override 
  String toString() => "Record<$name>";

}