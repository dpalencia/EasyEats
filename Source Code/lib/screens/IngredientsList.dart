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
  // The returned streambuilder will listen for updates 
  // to the DB and update itself with live data.
  // The streambuilder will rebuild everything beneath,
  // any time the data changes.

  // A list of filters, which will cause state to update and the list to rebuild
  // When filters are applied.

  final List<Tab> _theTabs = <Tab> [
    Tab(text: "Browse"),
    Tab(text: "Shopping List"),
    Tab(text: "My Kitchen")
  ];

  TabController _tabController;
  List<String> userShoppingList;
  List<String> userMyKitchen;

  @override 
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _theTabs.length);
  }

  @override 
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /* Predicates to pass into ingredient lists. 
  ** These are the predicates which will
  ** filter the list of ingredients. 
  (DocumentSnapshot, ) => boolean
  */

  bool predShoppingList(Ingredient ingredient) {
    return userShoppingList.contains(ingredient.getName());
  }

  void setUserData(String userID) async {
    Map<String, dynamic> userData = await getUserData(userID);
    userShoppingList = userData["shoppingList"].cast<String>().toList();
    userMyKitchen = userData["myKitchen"].cast<String>().toList();
  }

  @override
  Widget build(BuildContext context) {
    // Statefully render either a single ingredient
    // Or the list of ingredients if no ingredient is defined
    // In this state object.
    String userID = getTheUserID(context); // Using account helper
    if(this.mounted) setUserData(userID); // ensure widget is in tree
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
            IngredientListing(setIngredient),
            ShoppingList(setIngredient),
            IngredientListing(setIngredient)
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


/* Refactored, generalized listing of ingredients */
class IngredientListing extends StatefulWidget {
  /* Methods */
  var _setIngredient;

  /* Constructor */
  IngredientListing(this._setIngredient);
  @override
  createState() => IngredientListingState(this._setIngredient);
}

class IngredientListingState extends State<IngredientListing> {
  IngredientListingState(this._setIngredient);

  /* Methods */
  final List<String> _filters = new List<String>();
  List<Ingredient> ingredientList;

  /* State managemment */
  var _setIngredient; // Sets ingredient state. Passed into the ingredient tile widget.

  /* Ensure the filters are initialized. */
  @override 
  void initState() {
      super.initState();
  }

  void setTheIngredients(BuildContext context) async {
    Firestore.instance.collection('ingredients').getDocuments().then((snapshot) =>
        setState( () {
          ingredientList = _buildList(snapshot.documents);
        })
     );
  }

  /* Build */
  @override
  build(BuildContext context) {
    // Each listing view of ingredients will be:
    // The filter buttons
    // Followed by the list.
    setTheIngredients(context);
    if(ingredientList != null) 
      return ListView(
        children: _buildIngredientWidgets()
      );
    else 
      return CircularProgressIndicator();
  }

  List<Widget> _buildIngredientWidgets() {
    return ingredientList.map((ingredient) => _buildIngredientTile(ingredient)).toList();
  }

  List<Ingredient> _buildList(List<DocumentSnapshot> snapshot) {
    return snapshot.map((snap) => _buildIngredient(snap)).toList();
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
    return IngredientTile(_setIngredient, ingredient); 
  }


  Widget _buildFilters() {
  /* Build the Filters. One for each category. */
  /* Get the categories from the database. */
  return StreamBuilder(
    stream: Firestore.instance.collection("categories").snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if(!snapshot.hasData) return CircularProgressIndicator();
      List<dynamic> ingredientList = snapshot.data.documents[0].data["ingredients"];
      /* Cast the result of the map function as <Widget> to avoid errors. */
      List<Widget> chipList = ingredientList.map<Widget>((name) => createChip(name)).toList();
      return ListView(
        children: chipList
        );
      }
    );
  }

  Widget createChip(String label) {
  /* The label string will be used to determine which are selected. */
  /* Statefully update the array, which tells us which categories are currently selected. */
    return FilterChip(
      label: Text(label),
      selected: _filters.contains(label),
      onSelected: (bool v) {
          setState( () {
          if(v) this._filters.add(label);
          else _filters.removeWhere((name) => name == label);
        });
      }
    );
  }

  /* Functional helpers */
  void filterCallback(bool v, String label) {
    setState(() {
          if(v) _filters.add(label);
          else _filters.removeWhere((name) => name == label);
      });
  }
/*
  bool theIngredientFilter(DocumentSnapshot snapshot) {
    return _filterPredicate(snapshot) || _filters.contains(snapshot.data["name"]);
  }
*/
}

class ShoppingList extends IngredientListing {
  ShoppingList(setIngredient): super(setIngredient);
  @override
  createState() => ShoppingListState(_setIngredient);
}

class ShoppingListState extends IngredientListingState {
  ShoppingListState(setIngredient): super(setIngredient);
  @override 
  void setTheIngredients(context) async {
    String uid = getTheUserID(context);
    Map<String, dynamic> userData = await getUserData(uid);
    List<String> userShoppingList = userData["shoppingList"].cast<String>().toList();
    Firestore.instance.collection('ingredients').getDocuments().then((snapshot) =>
        setState( () {
          ingredientList = _buildList(snapshot.documents)
          .where((ingredient) => userShoppingList.contains(ingredient.getName())).toList();
        })
     );
  }
}
/*
class MyKitchen extends IngredientListing {
  MyKitchen(setIngredient): super(setIngredient);
  @override 
  createState() => MyKitchenState(_setIngredient);
}

class MyKitchenState extends IngredientListingState {
  MyKitchenState(setIngredient): super(setIngredient);
    void setTheIngredients(ccontext) {
    // TODO: implement setTheIngredients
    super.setTheIngredients();
  }
}
*/