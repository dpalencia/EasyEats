import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';

class IngredientTile extends StatefulWidget {
  final DocumentSnapshot _data; // Data for this tile.
  final _screenCallback;
  IngredientTile(this._data, this._screenCallback); // Pass the data down to its state.
  @override 
  createState() => IngredientTileState(this._data, this._screenCallback, Ingredient.fromSnapshot(_data));  // Create state.
}

class IngredientTileState extends State<IngredientTile> {
  final DocumentSnapshot _data; // The data field.
  final _screenCallback;
  final Ingredient _ingredient;
  bool _isInShoppingCart = false;

  IngredientTileState(this._data, this._screenCallback, this._ingredient); // Initialize the data field in consructor.
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

  InkWell _buildIcon() {
    return InkWell(
      onTap: (_isInShoppingCart ? removeFromShoppingCart : addToShoppingCart),
      child: Icon(
        (_isInShoppingCart ? Icons.remove_shopping_cart: Icons.add_shopping_cart)
      )
    );
  }

  @override
  build(BuildContext context) {
     return Padding(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_ingredient.imageURL)
              ),
              trailing: _buildIcon(),
              title: Text(_ingredient.name),
              onTap: () { _screenCallback (_ingredient); }
            ), 
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
     ); 
  }
}