import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Dish.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';

class FavoriteButton extends StatelessWidget {
  // Build a tappable favorites icon based on live database data.
  // Tapping will add/remove the dish from the user favorites.
  final Dish _dish;
  FavoriteButton(this._dish);
  @override
  build(BuildContext context) {
    return StreamBuilder(
              stream: Firestore.instance.collection("user").document(getTheUserID(context)).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snap) {
                List<dynamic> userFavorites = snap.data["favoriteRecipes"].toList();
                bool isInFavorites = snap.data["favoriteRecipes"].any((element) => element.path == _dish.ref.path);
                return IconButton(
                  icon: Icon(isInFavorites ? Icons.star : Icons.star_border),
                  onPressed: () {
                    if(isInFavorites) removeFromFavorites(userFavorites, snap.data.reference, context);
                    else addToFavorites(userFavorites, snap.data.reference, context);
                  }
                );
              }
    );
  }

  void removeFromFavorites(List<dynamic> favList, DocumentReference userRef, BuildContext context) {
    favList.removeWhere((element) => element.path == _dish.ref.path);
    userRef.updateData({"favoriteRecipes" : favList});
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(_dish.name + " added to favorites."),
          duration: Duration(seconds: 1)
        )
    );
  }

  void addToFavorites(List<dynamic> favList, DocumentReference userRef, BuildContext context) {
    favList.add(_dish.ref);
    userRef.updateData({"favoriteRecipes" : favList});
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(_dish.name + " removed from favorites."),
          duration: Duration(seconds: 1)
        )
    );
  }

}