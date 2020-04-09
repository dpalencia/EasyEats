import 'package:odysseusrecipes/screens/Root.dart';

import '../main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';


class IngredientTile extends StatefulWidget {
  final _screenCallback;
  IngredientTile(this._screenCallback); // Pass the data down to its state.
  @override 
  createState() => IngredientTileState(this._screenCallback);  // Create state.
}

class IngredientTileState extends State<IngredientTile> {
  final _screenCallback;
  Ingredient _ingredient;
  bool _isInShoppingCart = false;
  IngredientTileState(this._screenCallback); // Initialize the data field in consructor.
  void addToShoppingCart() {
    setState( () {
      _isInShoppingCart = true;  

    } 
    );
  }
  void removeFromShoppingCart() {
    setState( () {
      _isInShoppingCart = false;  
    }
    );
  }

  InkWell _buildIcon(String userID) {
    return InkWell(
      onTap: _isInShoppingCart ? 
        () { setUserIngredient(_ingredient, userID); }
      : () {},
      child: Icon(
        (_isInShoppingCart ? Icons.remove_shopping_cart: Icons.add_shopping_cart)
      )
    );
  }


  void setUserIngredient(Ingredient ingredient, String user) {
    Map<String, dynamic> theUserData = getUserData(user);
    List<String> ingredients = theUserData["userIngredients"];
    print(ingredients.toString());
    //store.collection("user").document(user).setData();
  }

  @override
  build(BuildContext context) {
     RootState rootState = InheritRootState.of(context);
     String currentUID = rootState.getUser().uid;
     return Padding(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_ingredient.imageURL)
              ),
              trailing: _buildIcon(currentUID),
              title: Text(_ingredient.name),
              onTap: () { _screenCallback (_ingredient); }
            ), 
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
     ); 
  }
}