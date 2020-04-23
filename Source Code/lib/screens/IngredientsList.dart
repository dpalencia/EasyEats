import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/screens/SingleIngredient.dart';
import 'package:odysseusrecipes/classes/IngredientTile.dart';
import '../main.dart';

// DB Connection Based off:
// https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html
// https://pub.dev/documentation/firebase/latest/firebase_firestore/DocumentSnapshot-class.html
class IngredientsList extends StatefulWidget {
  @override 
  createState() => IngredientsListState();
}

class IngredientsListState extends State<IngredientsList> with SingleTickerProviderStateMixin {
  Ingredient _ingredient;
  
  final List<Tab> _theTabs = <Tab> [
    Tab(text: "Browse"),
    Tab(text: "Shopping List"),
    Tab(text: "My Kitchen")
  ];
  TabController _tabController;

  List<String> filters;
  List<String> userShoppingList;
  List<String> userMyKitchen;
  
  List<Ingredient> browseList;
  List<Ingredient> shoppingList;
  List<Ingredient> myKitchen;

/*
  List<Widget> browseWidgets;
  List<Widget> shoppingWidgets;
  List<Widget> myKitchenWidgets;
*/
  Map<String, List<Widget>> widgetLists = {
    "browse": List<Widget>(),
    "shopping": List<Widget>(),
    "myKitchen": List<Widget>()
  };

  @override 
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _theTabs.length);
    setBrowseList();
    setShoppingList();
    setMyKitchen();
  }

  @override 
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void addToList(Widget thisTile, String listName) {
    setState(() {
      widgetLists[listName].add(thisTile);
    });
  }
  
  void removeFromList(Widget thisTile, String listName) {
    setState(() {
      widgetLists[listName].remove(thisTile);
    });
  }

  void setShoppingList() async {
      String uid = getTheUserID(context);
      Map<String, dynamic> userData = await getUserData(uid);
      userShoppingList = userData["shoppingList"].cast<String>().toList();
      if(mounted) {
        Firestore.instance.collection('ingredients').getDocuments().then((snapshot) =>
              setState( () {
                shoppingList = _buildList(snapshot.documents)
                .where((ingredient) => userShoppingList.contains(ingredient.getName())).toList();
                widgetLists["shopping"] = _buildIngredientWidgets(shoppingList);
            })
        );
      }
  }

  void setBrowseList() async {
      Firestore.instance.collection('ingredients').getDocuments().then((snapshot) {
          setState( () {
            browseList = _buildList(snapshot.documents);
            widgetLists["browse"] = _buildIngredientWidgets(browseList);
          });
        }
      );
      
  }

  void setMyKitchen() async {
      String uid = getTheUserID(context);
      Map<String, dynamic> userData = await getUserData(uid);
      userMyKitchen = userData["myKitchen"].cast<String>().toList();
      Firestore.instance.collection('ingredients').getDocuments().then((snapshot) {
          setState( () {
            myKitchen = _buildList(snapshot.documents)
            .where((ingredient) => userMyKitchen.contains(ingredient.getName())).toList();
            widgetLists["myKitchen"] = _buildIngredientWidgets(myKitchen);
          });
        }
      );
  }

  Widget _buildTheListView(List<Widget> ingredientWidgetList) {
    if(ingredientWidgetList != null) 
      return ListView(
        key: UniqueKey(),
        children: ingredientWidgetList
      );
    else 
      return CircularProgressIndicator();
  }

  List<Ingredient> _buildList(List<DocumentSnapshot> snapshot) {
    return snapshot.map((snap) => _buildIngredient(snap)).toList();
  }
  
  List<Widget> _buildIngredientWidgets(List<Ingredient> ingredientList) {
    return ingredientList.map((ingredient) => _buildIngredientTile(ingredient)).toList();
  }

  Ingredient _buildIngredient(DocumentSnapshot snap) {
    return Ingredient.fromSnapshot(snap);
  }
  // Render the individual ingredient items.
  // These are:
  // ingredient.name
  // ingredient.description
  // ingredient.thumbnail
  Widget _buildIngredientTile(Ingredient ingredient) {
    return IngredientTile(setIngredient, ingredient, addToList, removeFromList, key: UniqueKey()); 
  }
  @override
  Widget build(BuildContext context) {
    // Statefully render either a single ingredient
    // Or the list of ingredients if no ingredient is defined
    // In this state object.

    if(_ingredient != null)
      return SingleIngredient(_ingredient, clearIngredient);
    else 
      return Scaffold( // Scaffold with two tabs
        appBar: AppBar(
          title: Text("Ingredients"),
          bottom: TabBar(
            controller: _tabController,
            tabs: _theTabs
            )
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _buildTheListView(widgetLists["browse"]),
            _buildTheListView(widgetLists["shopping"]),
            _buildTheListView(widgetLists["myKitchen"])
          ],
        )
    );
}
  void clearIngredient() {
    setState(() {
      _ingredient = null;
    });
  }

  void setIngredient(Ingredient ingredient) {
    setState( () {
      _ingredient = ingredient;
    });
  }
}
