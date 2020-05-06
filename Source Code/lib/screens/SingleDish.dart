import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/Dish.dart';
import 'package:odysseusrecipes/classes/FavoriteButton.dart';
import 'package:odysseusrecipes/classes/FieldIngredientStream.dart';
import 'package:odysseusrecipes/classes/FieldStepsStream.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
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

  @override initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _theTabs.length);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            // Use a stream builder to get live icon data.
            FavoriteButton(widget._dish)
          ],
          title: Text(widget._dish.name)
        ),
        body: Container(
          height: MediaQuery.of(context).copyWith().size.height, // <-- gets the screen height
          child: Column(children: <Widget>[
          IntrinsicHeight( 
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: FittedBox(
                      child:  Image.network(widget._dish.imageURL),
                      fit: BoxFit.fitHeight
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        listIcon(Icons.restaurant, widget._dish.prepTime.toString() + " minutes", "Prep"),
                        listIcon(Icons.timer, widget._dish.cookTime.toString() + " minutes", "Cook"),
                        listIcon(Icons.accessibility, widget._dish.difficultyLevel.toString(), "Difficulty")
                      ],
                    )
                  )
                ],
            )
          ),
          Container (
            color: Theme.of(context).primaryColor,
            child: TabBar(
            controller: _controller,
            tabs: _theTabs,
            )
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

  Widget listIcon(IconData icon, String title, String subTitle) {
    return ListTile(
      leading: Icon(
        icon
        ),
      title: Text(title),
      subtitle: Text(subTitle)
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




