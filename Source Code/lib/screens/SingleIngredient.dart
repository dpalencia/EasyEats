import 'package:flutter/material.dart';
import 'package:odysseusrecipes/functions/UIHelpers.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';

class SingleIngredient extends StatelessWidget {
  final Ingredient ingredient; // Ingredient object holds the data for this ingredient.
  final clearCallback;

  SingleIngredient(this.ingredient, this.clearCallback); // Build this object with Ingredient data.


  @override 
  build(BuildContext context) {
    return Scaffold(
      appBar: singlePageAppBar(context, clearCallback), // Defined in UI helpers.
      body: Column( 
        children: <Widget>[
          Image.network(ingredient.imageURL),
          Row(
            children: <Widget>[
              Text(ingredient.description)
            ],
          )
        ],
      )
    );
  }
}