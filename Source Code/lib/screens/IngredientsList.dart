import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/AllIngredientStream.dart';
import 'package:odysseusrecipes/classes/FieldIngredientStream.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';

// DB Connection Based off:
// https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html
// https://pub.dev/documentation/firebase/latest/firebase_firestore/DocumentSnapshot-class.html
class IngredientsList extends StatefulWidget {
  @override 
  createState() => IngredientsListState();
}

class IngredientsListState extends State<IngredientsList> with SingleTickerProviderStateMixin {
  
  final List<Tab> _theTabs = <Tab> [
    Tab(text: "Browse"),
    Tab(text: "Shopping List"),
    Tab(text: "My Kitchen")
  ];
  TabController _tabController;

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
  @override
  Widget build(BuildContext context) {
    // Statefully render either a single ingredient
    // Or the list of ingredients if no ingredient is defined
    // In this state object.
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
            AllIngredientStream(),
            FieldIngredientStream(Firestore.instance.collection("user").document(getTheUserID(context)), "shoppingList"),
            FieldIngredientStream(Firestore.instance.collection("user").document(getTheUserID(context)), "myKitchen")
          ],
        )
    );
  }
}
