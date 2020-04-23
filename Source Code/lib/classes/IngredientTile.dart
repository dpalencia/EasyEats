import 'package:odysseusrecipes/screens/Root.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';


class IngredientTile extends StatefulWidget {
  final _screenCallback;
  final _ingredient;
  final _addToList;
  final _removeFromList;
  IngredientTile(this._screenCallback, this._ingredient, 
  this._addToList, this._removeFromList, {Key key}): super(key: key); // Pass the data down to its state.
  @override 
  createState() => IngredientTileState(_screenCallback, _ingredient, _addToList, _removeFromList);  // Create state.
}

class IngredientTileState extends State<IngredientTile> {
  final _addToList;
  final _removeFromList;
  final _screenCallback;
  Ingredient _ingredient;
  bool _isInShoppingCart = false;
  bool _isInKitchen = false;
  IngredientTileState(this._screenCallback, this._ingredient, this._addToList, this._removeFromList); // Initialize the data field in consructor.

  Row _buildIcon(String userID) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: _isInShoppingCart ? 
              () { removeShoppingIngredient(userID); }
            : () { setShoppingIngredient(userID); },
          child: Icon(
              (_isInShoppingCart ? Icons.remove_shopping_cart: Icons.add_shopping_cart)
            )
        ),
        InkWell(
          onTap: _isInKitchen ? 
              () { removeKitchenIngredient(userID); }
            : () { setKitchenIngredient(userID); },
          child: Icon(
              (_isInShoppingCart ? Icons.remove_shopping_cart: Icons.add_shopping_cart)
            )
        )
      ]
    );
  }

  void removeShoppingIngredient(String user) async {
    Firestore store = Firestore.instance;
    Map<String, dynamic> theUserData = await getUserData(user);
    List<dynamic> ingredients = theUserData["shoppingList"];
    if(ingredients.contains(_ingredient.name)) {
      ingredients.remove(_ingredient.name);
    }
    store.collection("user").document(user).updateData( {"shoppingList" : ingredients} );
    setIngredientState(user);
    _removeFromList(this.widget, "shopping");
  }

  void setShoppingIngredient(String user) async {
    Firestore store = Firestore.instance;
    Map<String, dynamic> theUserData = await getUserData(user);
    List<dynamic> ingredients = theUserData["shoppingList"];
    if(!ingredients.contains(_ingredient.name))
      ingredients.add(_ingredient.name);
    store.collection("user").document(user).updateData( {"shoppingList" : ingredients} );
    setIngredientState(user);
    _addToList(this.widget, "shopping");
  }

  void setKitchenIngredient(String user) async {
    List<dynamic> ingredients = await getIngredientList(user, "myKitchen");
    if(!ingredients.contains(_ingredient.name))
      ingredients.add(_ingredient.name);
    Firestore.instance.collection("user").document(user).updateData( {"myKitchen" : ingredients} );
    setIngredientState(user);
    _addToList(this.widget, "myKitchen");
  }

  void removeKitchenIngredient(String user) async {
    List<dynamic> ingredients = await getIngredientList(user, "myKitchen");
    if(!ingredients.contains(_ingredient.name))
      ingredients.remove(_ingredient.name);
    Firestore.instance.collection("user").document(user).updateData( {"myKitchen" : ingredients} );
    setIngredientState(user);
    _removeFromList(this.widget, "myKitchen");
  }

  Future<List<dynamic>> getIngredientList(String user, String list) async {
    Map<String, dynamic> theUserData = await getUserData(user);
    return theUserData[list].toList();
  }

  void setIngredientState(String user) async {
    Map<String, dynamic> theUserData = await getUserData(user);
    List<dynamic> shoppingList = theUserData["shoppingList"];
    List<dynamic> kitchen = theUserData["kitchen"];
    if(this.mounted) { // Ensure the state object is in a widget tree
      // Check database for ingredient; set state accordingly
      if(shoppingList.contains(_ingredient.name)) {
          setState(() {
            _isInShoppingCart = true;
          });
        }
      else {
        setState( () {
          _isInShoppingCart = false;
        });
      }
      if(kitchen.contains(_ingredient.name)) {
        setState(() {
            _isInKitchen = true;
          });
      } else {
        setState(() {
            _isInKitchen = false;
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