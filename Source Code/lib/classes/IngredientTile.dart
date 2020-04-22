import 'package:odysseusrecipes/screens/Root.dart';

import '../main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';


class IngredientTile extends StatefulWidget {
  final _screenCallback;
  final _ingredient;
  IngredientTile(this._screenCallback, this._ingredient); // Pass the data down to its state.
  @override 
  createState() => IngredientTileState(_screenCallback, _ingredient);  // Create state.
}

class IngredientTileState extends State<IngredientTile> {
  final _screenCallback;
  Ingredient _ingredient;
  bool _isInShoppingCart = false;
  IngredientTileState(this._screenCallback, this._ingredient); // Initialize the data field in consructor.

  InkWell _buildIcon(String userID) {
    return InkWell(
      onTap: _isInShoppingCart ? 
        () { removeUserIngredient(userID); }
      : () { setUserIngredient(userID); },
      child: Icon(
        (_isInShoppingCart ? Icons.remove_shopping_cart: Icons.add_shopping_cart)
      )
    );
  }

  void removeUserIngredient(String user) async {
    Firestore store = Firestore.instance;
    Map<String, dynamic> theUserData = await getUserData(user);
    List<dynamic> ingredients = theUserData["shoppingList"];
    if(ingredients.contains(_ingredient.name)) {
      ingredients.remove(_ingredient.name);
    }
    store.collection("user").document(user).setData( {"shoppingList" : ingredients} );
    setIngredientState(user);
  }

  void setUserIngredient(String user) async {
    Firestore store = Firestore.instance;
    Map<String, dynamic> theUserData = await getUserData(user);
    List<dynamic> ingredients = theUserData["shoppingList"];
    if(!ingredients.contains(_ingredient.name))
      ingredients.add(_ingredient.name);
    print(ingredients.toString());
    store.collection("user").document(user).setData( {"shoppingList" : ingredients} );
    setIngredientState(user);
  }

  void setIngredientState(String user) async {
    Map<String, dynamic> theUserData = await getUserData(user);
    List<dynamic> ingredients = theUserData["shoppingList"];
    if(this.mounted) { // Ensure the state object is in a widget tree
      // Check database for ingredient; set state accordingly
      if(ingredients.contains(_ingredient.name)) {
          setState(() {
            _isInShoppingCart = true;
          });
        }
      else {
        setState( () {
          _isInShoppingCart = false;
        });
      }
    }
  }

  @override
  build(BuildContext context) {
     RootState rootState = InheritRootState.of(context);
     String currentUID = rootState.getUser().uid;
     setIngredientState(currentUID);
     return Padding(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_ingredient.imageURL)
              ),
              trailing: _buildIcon(currentUID),
              title: Text(_ingredient.name),
              onTap: () { _screenCallback (_ingredient); } // Set parent state to current ingredient
            ), 
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
     ); 
  }
}