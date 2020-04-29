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
//  main() => runApp(MaterialApp(
//       home: DishesList(),
//     ));

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
            onTap(context);
          }, //TODO: Update onTap function to not be hardcoded
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.contain,
                child: Image.network(dishObjects[index].imageURL),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(), //filler container
                  textContainer(dishObjects[index].name), 
                  starContainer/*(pass in something for on tap )*/,
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


void onTap(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SingleDish()));
}
Widget textContainer(dynamic name) {
            return Container(
                          // width: 150.0,
                          height: 50.0,
                          //color: Colors.orange[400],
                          alignment:Alignment.center,
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
var starContainer = Container(
                    // width:40,
                    height:50,
                    //color: Colors.blue[100],
                    alignment: Alignment.center,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                            //TODO: add dish to favorites
                          },
                      child: Icon(
                        Icons.star
                      ),
                ),
              );