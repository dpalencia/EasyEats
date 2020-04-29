import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/screens/Root.dart';
import 'package:odysseusrecipes/classes/IngredientTile.dart';

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

  
/*
  Set<Ingredient> browseList;
  Set<Ingredient> shoppingList;
  Set<Ingredient> myKitchen;
*/
/*
  List<Widget> browseWidgets;
  List<Widget> shoppingWidgets;
  List<Widget> myKitchenWidgets;
*/

  Map<String, Set<Ingredient>> widgetLists = {
    "browse": Set<Ingredient>(),
    "shopping": Set<Ingredient>(),
    "myKitchen": Set<Ingredient>()
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

  void addToList(IngredientTile thisTile, String listName) {
    if(!widgetLists[listName].contains(thisTile.getIngredient())) {
      setState(() {
        widgetLists[listName].add(thisTile.getIngredient());
      });
    }
  }
  
  void removeFromList(IngredientTile thisTile, String listName) {
    setState(() {
      widgetLists[listName].remove(thisTile.getIngredient());
    });
  }


  void setShoppingList() async {
      String uid = getTheUserID(context);
      Map<String, dynamic> userData = await getUserData(uid);
      var userShoppingList = userData["shoppingList"].cast<String>().toSet();
      if(mounted) {
        Firestore.instance.collection('ingredients').getDocuments().then((snapshot) =>
              setState( () {
                widgetLists["shopping"] = _buildList(snapshot.documents)
                .where((ingredient) => userShoppingList.contains(ingredient.getName())).toSet();
                //widgetLists["shopping"] = _buildIngredientWidgets(shoppingList);
            })
        );
      }
  }

  void setBrowseList() async {
      Firestore.instance.collection('ingredients').getDocuments().then((snapshot) {
          setState( () {
            widgetLists["browse"] = _buildList(snapshot.documents);
            //widgetLists["browse"] = _buildIngredientWidgets(browseList);
          });
        }
      );
      
  }

  void setMyKitchen() async {
      String uid = getTheUserID(context);
      Map<String, dynamic> userData = await getUserData(uid);
      var userMyKitchen = userData["myKitchen"].cast<String>().toSet();
      Firestore.instance.collection('ingredients').getDocuments().then((snapshot) {
          setState( () {
           widgetLists["myKitchen"] = _buildList(snapshot.documents)
            .where((ingredient) => userMyKitchen.contains(ingredient.getName())).toSet();
            //widgetLists["myKitchen"] = _buildIngredientWidgets(myKitchen);
          });
        }
      );
  }


  Widget _buildTheListView(String listID)  {
    if(widgetLists[listID] == null) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
      itemCount: widgetLists[listID].length,
      itemBuilder: (BuildContext context, int index) {
        return _buildIngredientTile(widgetLists[listID].elementAt(index));
      }
    );
  }

/*
  Widget _buildTheListView(List<Widget> ingredientWidgetList) {
    if(ingredientWidgetList != null) 
      return ListView(
        key: UniqueKey(),
        children: ingredientWidgetList
      );
    else 
      return CircularProgressIndicator();
  }
*/
  Set<Ingredient> _buildList(List<DocumentSnapshot> snapshot) {
    return snapshot.map((snap) => _buildIngredient(snap)).toSet();
  }
  /*
  List<Widget> _buildIngredientWidgets(Set<Ingredient> ingredientList) {
    return ingredientList.map((ingredient) => _buildIngredientTile(ingredient)).toSet();
  }
*/
  Ingredient _buildIngredient(DocumentSnapshot snap) {
    return Ingredient.fromSnapshot(snap);
  }

  // Render the individual ingredient items.
  // These are:
  // ingredient.name
  // ingredient.description
  // ingredient.thumbnail
  Widget _buildIngredientTile(Ingredient ingredient) {
    RootState rootState = InheritRootState.of(context);
    String uid = rootState.getUser().uid;
    return IngredientTile(ingredient, addToList, removeFromList, uid, key: Key(ingredient.getName())); 
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
            _buildTheListView("browse"),
            _buildTheListView("shopping"),
            _buildTheListView("myKitchen")
          ],
        )
    );
  }
}
