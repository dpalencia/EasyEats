import 'package:odysseusrecipes/screens/Root.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';


class IngredientTile extends StatefulWidget {
  final _ingredient;
  final _addToList;
  final _removeFromList;
  IngredientTile(this._ingredient, this._addToList, 
  this._removeFromList, this._userID, {Key key}): super(key: key); // Pass the data down to its state.
  final String _userID;

  getIngredient() { return _ingredient; }

  @override 
  createState() => IngredientTileState(_ingredient, _addToList, _removeFromList, _userID);  // Create state.
}

class IngredientTileState extends State<IngredientTile> {
  final _addToList;
  final _removeFromList;
  Ingredient _ingredient;
  bool _isInShoppingCart;
  bool _isInKitchen;
  final String _userID;
  IngredientTileState(this._ingredient, this._addToList, this._removeFromList, this._userID); // Initialize the data field in consructor.
  @override initState() {
    super.initState();
    setKitchenBool();
    setShoppingBool();
  }


  Widget _buildIcon(String userID) {
    if((_isInKitchen == null) || (_isInShoppingCart == null)) 
      return CircularProgressIndicator();
    return Row(
      mainAxisSize: MainAxisSize.min,
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
              (_isInKitchen ? Icons.remove: Icons.add)
            )
        )
      ]
    );
  }



  Future<List<dynamic>> getListFromDatabase(String listID) async {
    Map<String, dynamic> theUserData = await(getUserData(_userID));
    return theUserData[listID];
  }

  /* Remove an ingredient from shopping list and update state. */
  void removeShoppingIngredient(String user) async {
    List<dynamic> ingredients = await getListFromDatabase("shoppingList");

    if(ingredients.contains(_ingredient.reference.documentID)) {
      ingredients.remove(_ingredient.reference.documentID);
    }
    // Update ingredient in database
    Firestore.instance.collection("user").document(user).updateData( {"shoppingList" : ingredients} );

    // Statefully update Shopping List button
    setShoppingBool();
    _removeFromList(this.widget, "shopping");
  }

  /* Set an ingredient in shopping list and update state of this tile and parent state widget. */
  void setShoppingIngredient(String user) async {
    List<dynamic> ingredients = await getListFromDatabase("shoppingList");
    if(!ingredients.contains(_ingredient.reference.documentID))
      ingredients.add(_ingredient.reference.documentID);
    Firestore.instance.collection("user").document(user).updateData( {"shoppingList" : ingredients} );
    setShoppingBool();
    _addToList(this.widget, "shopping");
  }

  /* Set an ingredient in kitchen in the database and update state of this tile and parent state widget. */
  void setKitchenIngredient(String user) async {
    List<dynamic> ingredients = await getListFromDatabase("myKitchen");
    if(!ingredients.contains(_ingredient.reference.documentID))
      ingredients.add(_ingredient.reference.documentID);
    Firestore.instance.collection("user").document(user).updateData( {"myKitchen" : ingredients} );
    setKitchenBool();
    _addToList(this.widget, "myKitchen");
  }

  /* Remove an ingredient from kitchen in the database and update state of this tile and the parent state widget. */
  void removeKitchenIngredient(String user) async {
    List<dynamic> ingredients = await getListFromDatabase("myKitchen");
    if(ingredients.contains(_ingredient.reference.documentID))
      ingredients.remove(_ingredient.reference.documentID);
    Firestore.instance.collection("user").document(user).updateData( {"myKitchen" : ingredients} );
    setKitchenBool();
    _removeFromList(this.widget, "myKitchen");
  }



  // Check the database and update stateful _isInKitchen and _isInShoppingList.
  // This should cause the buttons to re-render.
  void setShoppingBool() async {
    // Get the most current version of the user's lists
    Map<String, dynamic> theUserData = await getUserData(_userID);
    List<dynamic> shoppingList = theUserData["shoppingList"];
    if(this.mounted) {
      if(shoppingList.contains(_ingredient.reference.documentID)) {
          setState(() {
              _isInShoppingCart = true;
          });
      } else {
          setState(() {
            _isInShoppingCart = false;
          });
      }
    }
}


  void setKitchenBool() async {
    // Same as setShoppingButtonState(), except for the MyKitchen list.
    Map<String, dynamic> theUserData = await getUserData(_userID);
    List<dynamic> myKitchen = theUserData["myKitchen"];
    if(this.mounted) {
      if(myKitchen.contains(_ingredient.reference.documentID)) {
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
     return Padding(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_ingredient.imageURL)
              ),
              trailing: _buildIcon(_userID),
              title: Text(_ingredient.name),
              //onTap: () { _screenCallback (_ingredient); } // Set parent state to current ingredient
            ), 
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
     ); 
  }
}