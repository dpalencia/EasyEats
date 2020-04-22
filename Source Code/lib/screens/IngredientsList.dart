import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
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

  // _filters needs to be statefully managed.
  // Becuse of the chips.

  List<String> _filters;


  final List<Tab> _theTabs = <Tab> [
    Tab(text: "Ingredients"),
    Tab(text: "Categories")
  ];

  TabController _tabController;

  @override 
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _theTabs.length);
    _filters = new List<String>();
  }

  @override 
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          title: Text("Ingredients List"),
          bottom: TabBar(
            controller: _tabController,
            tabs: _theTabs
            )
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _buildListTab(),
            _buildFilters()
          ],
        )
    );
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

void filterCallback(bool v, String label) {
  setState(() {
        if(v) _filters.add(label);
        else _filters.removeWhere((name) => name == label);
    });
}


Widget _buildListTab() {
    return StreamBuilder<QuerySnapshot> (
      // The firestore snapshots() function
      // Handles the details of the stream implementation.
      // Stream gives us a list of 
      stream: Firestore.instance.collection('ingredients').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // In the case of ingredients, we return a 
        // ListView widget which will hold our list of ingredients.
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(snapshot.data.documents); 
      }
    );
}
  

  Widget _buildList(List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> filtered = snapshot.where((snap) => filterIngredients(snap)).toList();
    return ListView(
      children: filtered.map((data) => _buildIngredient(data)).toList()
    );
  }

  bool filterIngredients(DocumentSnapshot snapshot) {
    return _filters.any((item) => snapshot.data["categories"].contains(item));
  }

  // Render the individual ingredient items.
  // These are:
  // ingredient.name
  // ingredient.description
  // ingredient.thumbnail
  Widget _buildIngredient(DocumentSnapshot snapshot) {
    return IngredientTile(setIngredient, Ingredient.fromSnapshot(snapshot)); 
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


