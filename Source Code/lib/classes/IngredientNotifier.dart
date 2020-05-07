import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Dish.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';

class IngredientNotifier extends StatelessWidget {
  final Dish _dish; // The dish data object
  IngredientNotifier(this._dish);
  // Get a count of how many ingredients the user is missing
  int getMissingCount(List<dynamic> userIngredients, List<dynamic> dishIngredients) {
     int ret = 0;
     dishIngredients.forEach((element) {
      // Iterate through ingredient list
      // And test if each ingredient is in the user's "My Kitchen"
      // Using the "any" method on the user my kitchen field.
      // Increment a counter of missing items, each time we get a miss.
      if(!userIngredients.any((item) => item.path == element.path)) {
        ret++;
      }
     }); 
    return ret;
  }  



  @override build(BuildContext context) {
    // We use a streambuilder to asynchronously
    // Render this widget with live, real time data.
    // We nest streambuilders to watch two streams at once!
    return StreamBuilder(
      stream: Firestore.instance.collection('user').document(getTheUserID(context)).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnap) {
        return StreamBuilder(
          stream: Firestore.instance.collection('dishes').document(_dish.ref.documentID).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> dishSnap) {
            if(dishSnap.connectionState == ConnectionState.waiting) return Text("Loading...");
            int missingCount = getMissingCount(userSnap.data["myKitchen"].toList(), dishSnap.data["ingredients"].toList());
            String displayText = (missingCount == 0)  ? "You have all the ingredients!"
                                  : "Ingredients missing: " + missingCount.toString();
            return Text(displayText, style: Theme.of(context).textTheme.body1, textAlign: TextAlign.left);
          }
        );
      }
    );
  }
}