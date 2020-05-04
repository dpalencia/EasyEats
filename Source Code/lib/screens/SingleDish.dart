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

class SingleDishState extends State<SingleDish> with SingleTickerProviderStateMixin {
  // Stateful fields.
  final List<Tab> _theTabs = <Tab> [
      Tab(text: "Instructions"),
      Tab(text: "Ingredients"),
    ];
  TabController _controller;

  // The ingredient list model, which we use to build the tiles.

  @override initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _theTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._dish.name)
        ),
        body: Container(
          height: MediaQuery.of(context).copyWith().size.height,
          child: Column(children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: FittedBox(
                  child:  Image.network(widget._dish.imageURL),
                  fit: BoxFit.cover
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    prepIcon(),
                    cookIcon(),
                    diffIcon()
                  ],
                )
              )
            ],
          ),
          TabBar(
            controller: _controller,
            tabs: _theTabs
          ),
          Expanded(
            child: TabBarView(
            controller: _controller,
            children: <Widget>[
              FieldStepsStream(widget._dish.ref, "steps"),
              FieldIngredientStream(widget._dish.ref, "ingredients", withAmounts: true)
            ],
          ))
          ],
        )),
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
    return ListTile(
      leading: Icon(Icons.restaurant),
      title: Text("Prep:\n" + widget._dish.prepTime.toString() + ' minutes')
    );
  }

  Widget cookIcon() { 
    return ListTile(
      leading: Icon(Icons.timer),
      title: Text("Cook:\n" + widget._dish.cookTime.toString() + ' minutes')
    );
  }

  Widget diffIcon() {
    return ListTile(
      leading: Icon(Icons.accessibility),
      title: Text("Difficulty:\n" + widget._dish.difficultyLevel.toString())
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




