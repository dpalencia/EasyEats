import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'Ingredient.dart';
//TODO: This widget doesn't look like it needs to be stateful.

class StreamIngredientTile extends StatefulWidget {
  StreamIngredientTile(this._ingredient, {this.amount});
  final Ingredient _ingredient;
  final String amount;
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
    String addRemove = listContainsIngredient ? "removed from" : "added to";
    String listName = fieldName == "shoppingList" ? "Shopping List" : "My Kitchen";
    return InkWell(
          onTap: () { 
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(widget._ingredient.name  + " " + addRemove + " " + listName + "."),
              duration: Duration(milliseconds: 750)
            ));
            listContainsIngredient ? removeFromList(snapshot, fieldName, userIngredientList) : addToList(snapshot, fieldName, userIngredientList); 
            },
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
     return SingleChildScrollView(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget._ingredient.imageURL)
              ),
              trailing: buildIcon(context),
              title: Text(widget._ingredient.name),
              subtitle: widget.amount != null ? Text(widget.amount) : null
            ), 
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
     ); 
  }
}