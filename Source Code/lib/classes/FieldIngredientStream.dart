import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:odysseusrecipes/classes/StreamIngredientTile.dart';

class FieldIngredientStream extends StatelessWidget {
  final DocumentReference _docRef;
  final String _fieldName;
  final bool withAmounts;
  FieldIngredientStream(this._docRef, this._fieldName, {this.withAmounts = false});
  @override 
  build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot> (
      // Links to a snapshot of a particular document
      stream: _docRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        // The outer build returns the ListView.
        return SizedBox(
          child: ListView.builder(
          shrinkWrap: true,
          // Now watch the specified data field
          itemCount: snapshot.data[_fieldName].length,
          itemBuilder: (BuildContext context, int index) {
              return StreamBuilder<DocumentSnapshot>(
                // The inner streambuilder builds itself from the reference to the dish.
                stream: snapshot.data[_fieldName][index].snapshots(), // <-- this takes the reference and gives us it to us as a snapshot we can watch.
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> ingredient) {
                  // Here we're getting the individual document snapshots for the individual ingredients.
                  if(ingredient.connectionState == ConnectionState.waiting) return Column();
                  if(withAmounts) return StreamIngredientTile(Ingredient.fromSnapshot(ingredient.data), amount: snapshot.data["ingredientAmounts"][index]);
                  return StreamIngredientTile(Ingredient.fromSnapshot(ingredient.data)
                  );
                }
              );
            }
            )
            );
          }
        );
      }  
}


/*



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:odysseusrecipes/classes/StreamIngredientTile.dart';

class FieldIngredientStream extends StatelessWidget {
  final DocumentReference _docRef;
  final String _fieldName;
  final bool withAmounts;
  FieldIngredientStream(this._docRef, this._fieldName, {this.withAmounts = false});
  @override 
  build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot> (
      // Links to a snapshot of a particular document
      stream: _docRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        // The outer build returns the ListView.
        return SizedBox(
          height: 200,
          child: ListView.builder(
          shrinkWrap: true,
          // Now watch the specified data field
          itemCount: snapshot.data[_fieldName].length,
          itemBuilder: (BuildContext context, int index) {
              return StreamBuilder<DocumentSnapshot>(
                // The inner streambuilder builds itself from the reference to the dish.
                stream: snapshot.data[_fieldName][index].snapshots(), // <-- this takes the reference and gives us it to us as a snapshot we can watch.
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> ingredient) {
                  // Here we're getting the individual document snapshots for the individual ingredients.
                  if(ingredient.connectionState == ConnectionState.waiting) return Column();
                  if(withAmounts) return StreamIngredientTile(Ingredient.fromSnapshot(ingredient.data), amount: snapshot.data["ingredientAmounts"][index]);
                  return StreamIngredientTile(Ingredient.fromSnapshot(ingredient.data));
                }
              );
            }
            ));
          }
        );
      }  
}

*/