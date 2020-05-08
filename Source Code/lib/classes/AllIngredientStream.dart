import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:odysseusrecipes/classes/StreamIngredientTile.dart';


// List ALL of the Ingredients.
class AllIngredientStream extends StatelessWidget {
  @override 
  build(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      // Links to a snapshot of a particular collection
      stream: Firestore.instance.collection("ingredients").snapshots(),
      // Create a listview from all fo the documents in this collection.
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            // Instantiate ingredients from the data we have in this snapshot.
            return StreamIngredientTile(Ingredient.fromSnapshot(snapshot.data.documents[index]));
          }
        );
      }
    );
  }
}


