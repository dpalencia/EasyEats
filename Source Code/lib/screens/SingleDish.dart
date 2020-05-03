import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Dish.dart';
import 'package:odysseusrecipes/classes/FieldIngredientStream.dart';
import 'package:odysseusrecipes/classes/FieldStepsStream.dart';
class SingleDish extends StatefulWidget {
  // The constructor will take the _dish argument and build the state with it.
  final Dish _dish;
  SingleDish(this._dish);
  @override
  createState() => SingleDishState();
}

class SingleDishState extends State<SingleDish> {
  // Stateful fields.
  bool _isOpen = true;

  // The ingredient list model, which we use to build the tiles.

  @override initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: heartButton(),
        appBar: AppBar(
          title: Text(widget._dish.name)
        ),
        body: ListView (
          children: <Widget>[
            FittedBox(
              child: Image.network(widget._dish.imageURL),
                fit: BoxFit.fill, // demo, replace with what user clicked on.
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                prepIcon(),
                cookIcon(),
                diffIcon(),
              ],
            ),
            ExpansionPanelList(
              children: <ExpansionPanel>[
                ExpansionPanel(
                  body: FieldStepsStream(widget._dish.ref, "steps"),
                  headerBuilder: (context, _isOpen) {
                    return Text("Steps");
                  },
                  isExpanded: true
                ),
                ExpansionPanel(
                  headerBuilder: (context, _isOpen) {
                    return Text("Ingredients");
                  },
                  body: FieldIngredientStream(widget._dish.ref, "ingredients", withAmounts: true),
                  isExpanded: true
                )
              ]
            )
          ],
        ),
      );
  }
    
    
/*                  FUNCTIONS & VARIABLES BELOW                            */
// Daniel: UI Helpers for building the Dish screen.
// I moved these inside the state class because they need to access the _dish object.
  Widget dishTitle() {
    return Text(
      widget._dish.name, // replace with actual name of dish
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        fontFamily: 'Roboto'
      )
    );
  }

  Widget ingredients() {
    return Text("Hello, world...");
  }

  Widget prepIcon() {
    return Container(
      child: Column(
        children: <Widget>[Icon(Icons.restaurant), Text('Prep Time:\n' + widget._dish.prepTime.toString() + ' minutes')],
      ),
    );
  }

  Widget cookIcon() { 
    return Container( 
      child: Column(
        children: <Widget>[Icon(Icons.timer), Text('Cook Time:\n' + widget._dish.cookTime.toString() + ' minutes')],
      ),
    );
  }

  Widget diffIcon() {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(Icons.accessibility),
          Text('Difficulty Level:\n' + widget._dish.difficultyLevel.toString())
        ],
      )
    );
  }

  Widget heartButton() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.orange[400],
        child: Icon(
          Icons.favorite,
          color: Colors.white,
        ),
        onPressed: null,
      ),
    );
  }
}




