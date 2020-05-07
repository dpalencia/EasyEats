//Works as intended but is currently hard coded to print just this one picture and only
//redirects to the single dish
//TODO: Clean it up make it a little nicer
//TODO: Implement Scroll Function
//TODO: Take in dishes from the database and use that info and images in functions
//rather than hard coding

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odysseusrecipes/screens/SingleDish.dart';
import 'package:odysseusrecipes/classes/Dish.dart';
import 'package:odysseusrecipes/functions/accountHelpers.dart';
import 'package:odysseusrecipes/classes/FavoriteButton.dart';
import '../main.dart';

class DishesList extends StatefulWidget {
  String _type='';
  DishesList();
  DishesList.type(String type){
    this._type=type;
  }
  createState() => (_type=='') ? DishesListState() : DishesListState.type(_type);
}


class DishesListState extends State<DishesList> {
  // The big list of dishes
  String _type="dishes";
  DishesListState();
  DishesListState.type(String type){
    this._type=type;
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
    });
  }
  void setDishObjects(String _type) {
    if(_type=="Favorites"){
    List<DocumentSnapshot> _favorites=List<DocumentSnapshot>();
    Firestore.instance.collection("user").document(getTheUserID(context)).get().then((snapshot) async {
      for(int i=0;i<snapshot.data["favoriteRecipes"].length;i++){
        _favorites.add(await snapshot.data["favoriteRecipes"][i].get());//?????????
      }
      buildDishList(_favorites);
      });
    }
    else{
    Firestore.instance.collection(_type).getDocuments().then((snapshot) {
      buildDishList(snapshot.documents);});
    }
  }

  // The main listview. Builds the widgets as they come in, based on predicates
  Widget theBuilderWidget() {
    return ListView(
      children: dishObjects.map((item) => dishCard(item)).toList()
      );
  }


  Widget dishCard(Dish dish) {
  return Center(
    child: Container(
        margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Card(
          child: InkWell(
          onTap: () {
            onTap(context, dish);
          }, 
            child: Column(
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.cover,
                  child: dish.imageURL == null ? null : Image.network((dish.imageURL))
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    dish.name == null ? Text("") : textContainer(dish.name, context), 
                    FavoriteButton(dish),
              ],
              ),
            )
            ],
        ), 
      ),

    ),
  ),
  );
}



@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (_type=="dishes") ? Text("Dishes List") : Text(_type),
      ),
      body: (dishObjects == null) ? Center(child: CircularProgressIndicator()) : theBuilderWidget()
      );
  }
}


void onTap(BuildContext context, Dish dish) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SingleDish(dish)));
}
Widget textContainer(dynamic name, BuildContext context) {
            return Container(
                          alignment:Alignment.center,
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.subhead
                          ),
                        );
}
