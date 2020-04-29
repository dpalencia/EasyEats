
import 'package:cloud_firestore/cloud_firestore.dart';

class Dish {
  // Take a DocumentSnapshot and unpack it into these fields.
  final categories;
  final cookTime;
  final prepTime;
  final rating;
  final description;
  final difficultyLevel;
  final imageURL;
  final name; 

  // The constructor which initializes the fields.
  Dish(this.categories, this.cookTime,
  this.prepTime, this.rating, this.description,
  this.difficultyLevel, this.imageURL, this.name);

  //The named constructor that takes the map, and unpacks it into the fields.
  Dish.fromMap(Map<String, dynamic> theData): this(theData["categories"], 
  theData["cookTime"], theData["prepTime"], theData["rating"], theData["description"],
    theData["difficultyLevel"], theData["imageURL"], theData["name"]);

  // The named constructor that takes a snapshot and gets the Map with the data.
  Dish.fromSnapshot(DocumentSnapshot snapshot): this.fromMap(snapshot.data);

}
