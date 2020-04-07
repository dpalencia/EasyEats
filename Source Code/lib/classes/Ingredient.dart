import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  // The fields
  final String name; 
  final String description;
  final List categories;
  final DocumentReference reference;
  final String imageURL;

  // Defining named constructors from initializer list.
  Ingredient(name, description, categories, reference, url): 
    name = name, description = description, 
    reference = reference,
    categories = categories,
    imageURL = url;

  Ingredient.fromMap(Map<String, dynamic> map, DocumentReference reference) 
    : this(map['name'], map['description'], map['categories'], reference, map['imageURL']);
  Ingredient.fromSnapshot(DocumentSnapshot snapshot) 
    : this.fromMap(snapshot.data, snapshot.reference);
  @override 
  String toString() => "Record<$name>";
}