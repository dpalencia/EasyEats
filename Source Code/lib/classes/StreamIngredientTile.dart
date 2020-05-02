import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'Ingredient.dart';

class StreamIngredientTile extends StatefulWidget {
  StreamIngredientTile(this._ingredient);
  final Ingredient _ingredient;
  @override
  createState() => StreamIngredientState();
}

class StreamIngredientState extends State<StreamIngredientTile> {
  Widget buildIcon(BuildContext context) {
    return StreamBuilder<DocumentSnapshot> (
      // A stream of document snapshots.
      stream: Firestore.instance.collection('user').document(getTheUserID(context)).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            iconStreamBuilder(snapshot, "shoppingList", Icons.add_shopping_cart, Icons.remove_shopping_cart),
            iconStreamBuilder(snapshot, "myKitchen", Icons.add, Icons.remove)
        ]
        );
      } // Builder lambda
    );
  }

  Widget iconStreamBuilder(snapshot, fieldName, addIcon, removeIcon) {
    List<dynamic> userIngredientList = snapshot.data[fieldName].toList();
    bool listContainsIngredient = userIngredientList.any((element) => widget._ingredient.reference.path == element.path);
    return InkWell(
          onTap: () { listContainsIngredient ? removeFromList(snapshot, fieldName, userIngredientList) : addToList(snapshot, fieldName, userIngredientList); },
          child: Icon( listContainsIngredient ? removeIcon : addIcon)
        );
  }

  void removeFromList(snapshot, String fieldName, List<dynamic> userIngredientList) {
    userIngredientList.removeWhere((element) => element.path == widget._ingredient.reference.path);
    snapshot.data.reference.updateData({fieldName: userIngredientList});
  }
  void addToList(snapshot, String fieldName, List<dynamic> userIngredientList) {
   userIngredientList.add(widget._ingredient.reference);
   snapshot.data.reference.updateData({fieldName: userIngredientList});
  }

  @override
  build(BuildContext context) {
     return Padding(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget._ingredient.imageURL)
              ),
              trailing: buildIcon(context),
              title: Text(widget._ingredient.name),
            ), 
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
     ); 
  }
}