//Works as intended but is currently hard coded to print just this one picture and only
//redirects to the single dish
//TODO: Clean it up make it a little nicer
//TODO: Implement Scroll Function
//TODO: Take in dishes from the database and use that info and images in functions
//rather than hard coding

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/screens/SingleDish.dart';
import 'package:odysseusrecipes/classes/Dish.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/classes/FavoriteButton.dart';

//I have this for testing purposes
//change class name back to DishesList and remove main function.
//  main() => runApp(MaterialApp(
//       home: DishesList(),
//     ));

class DishesList extends StatefulWidget {
  String _type = '';
  DishesList();
  DishesList.type(String type) {
    this._type = type;
  }
  createState() =>
      (_type == '') ? DishesListState() : DishesListState.type(_type);
}

class DishesListState extends State<DishesList> {
  // The big list of dishes
  bool vegetarianbool = true;
  bool meatbool = true;
  bool bakingbool = true;
  List<Dish> meat, vegetarian, baking;
  String _type = "dishes";
  DishesListState();
  DishesListState.type(String type) {
    this._type = type;
  }
  List<Dish> dishObjects;
  @override
  void initState() {
    super.initState();
    setDishObjects(_type);
  }

  void buildDishList(List<DocumentSnapshot> docSnaps) {
    setState(() {
      dishObjects = docSnaps.map((snap) => Dish.fromSnapshot(snap)).toList();
      makeCategoryLists();
    });
  }

  void setDishObjects(String _type) {
    if (_type == "Favorites") {
      List<DocumentSnapshot> _favorites = List<DocumentSnapshot>();
      Firestore.instance
          .collection("user")
          .document(getTheUserID(context))
          .get()
          .then((snapshot) async {
        for (int i = 0; i < snapshot.data["favoriteRecipes"].length; i++) {
          _favorites.add(await snapshot.data["favoriteRecipes"][i].get());
        }
        buildDishList(_favorites);
      });
    } else {
      Firestore.instance.collection(_type).getDocuments().then((snapshot) {
        buildDishList(snapshot.documents);
      });
    }
  }

  // The main listview. Builds the widgets as they come in, based on predicates
  Widget theBuilderWidget() {
    return ListView.builder(
        itemCount: dishObjects.length, itemBuilder: theBuilderFunction);
  }

  Widget theBuilderFunction(BuildContext context, int index) {
    return dishCard(index);
  }

  Widget dishCard(int index) {
    return Center(
      child: Container(
        height: 300,
        child: Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              onTap(context, dishObjects[index]);
            }, //TODO: Update onTap function to not be hardcoded
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                flex: 1,
                  child:Container(
                    height:200,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.network(dishObjects[index].imageURL),
                    ),
                    ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(), //filler container
                    textContainer(dishObjects[index].name),
                    FavoriteButton(dishObjects[index]),
                  ],
                ),
              ],
            ),
          ),
          elevation: 100,
          margin: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget filterDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppBar(
            title: Text(
              "Filters",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          CheckboxListTile(
            title: const Text('Vegetarian'),
            value: vegetarianbool,
            onChanged: (bool value) {
              print(value.toString());
              if (!value) {
                for (int i = 0; i < dishObjects.length; i++) {
                  if (dishObjects[i].categories.contains("Vegetarian")) {
                    dishObjects.removeAt(i);
                    i--;
                  }
                }
              } else if (value == true) {
                dishObjects += vegetarian;
              }
              setState(() {
                vegetarianbool = value;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Meat'),
            value: meatbool,
            onChanged: (bool value2) {
              if (!value2) {
                for (int i = 0; i < dishObjects.length; i++) {
                  if (dishObjects[i].categories.contains("Meat")) {
                    dishObjects.removeAt(i);
                    i--;
                  }
                }
              } else if (value2) {
                dishObjects += meat;
              }
              print(value2);
              setState(() {
                meatbool = value2;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Baking'),
            value: bakingbool,
            onChanged: (bool value) {
              if (!value) {
                for (int i = 0; i < dishObjects.length; i++) {
                  if (dishObjects[i].categories.contains("Baking")) {
                    dishObjects.removeAt(i);
                    i--;
                  }
                }
              } else if (value) {
                dishObjects += baking;
              }
              print(value);
              setState(() {
                bakingbool = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void makeCategoryLists() {
    vegetarian = dishObjects.where((e) => e.categories.contains("Vegetarian")).toList();
    meat = dishObjects.where((e) => e.categories.contains("Meat")).toList();
    baking = dishObjects.where((e) => e.categories.contains("Baking")).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (_type == "dishes") ? Text("Dishes List") : Text(_type),
      ),
      endDrawer: filterDrawer(),
      body: (dishObjects == null)
          ? CircularProgressIndicator()
          : theBuilderWidget(),
    );
  }
}

void onTap(BuildContext context, Dish dish) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SingleDish(dish)));
}

Widget textContainer(dynamic name) {
  return Container(
    // width: 150.0,
    height: 50.0,
    //color: Colors.orange[400],
    alignment: Alignment.center,
    child: Text(
      name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
    ),
  );
}
