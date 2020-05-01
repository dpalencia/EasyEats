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
import '../main.dart';

//I have this for testing purposes
//change class name back to DishesList and remove main function.
/* main() => runApp(MaterialApp(
      home: Home(),
    ));*/

class DishesList extends StatefulWidget {
  @override
  createState() => DishesListState();
}

class DishesListState extends State<DishesList> {
  // The big list of dishes
  List<Dish> dishObjects;
  
  @override 
  void initState() {
    super.initState();
    setDishObjects();
  }
  
  void buildDishList(List<DocumentSnapshot> docSnaps) {
    setState(() {
      dishObjects = docSnaps.map((snap) => Dish.fromSnapshot(snap)).toList();
    });
  }
  void setDishObjects() {
    Firestore.instance.collection("dishes").getDocuments().then((snapshot) {
      buildDishList(snapshot.documents);
    });
  }

  // The main listview. Builds the widgets as they come in, based on predicates
  Widget theBuilderWidget() {
    return ListView.builder(
      itemCount: dishObjects.length,
      itemBuilder: theBuilderFunction
    );
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
            children: <Widget>[
              FittedBox(
                fit: BoxFit.contain,
                child: Image.network(dishObjects[index].imageURL),
                // demo, replace with get image from database for example (have to pass in values).
              ),
              Container(
                width: 300,
                height: 50,
                child: Text(
                  dishObjects[index].name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
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



@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dishes List"),
      ),
      body: (dishObjects == null) ? CircularProgressIndicator() : theBuilderWidget()
      );
  }
}


void onTap(BuildContext context, Dish dish) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SingleDish(dish)));
}
//TODO: Currently hard coded to go to Chris's page
