import 'package:firebase_auth/firebase_auth.dart';
import 'package:odysseusrecipes/classes/Ingredient.dart'; 
//import 'package:odysseusrecipes/screens/Root.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odysseusrecipes/screens/Root.dart';

import '../main.dart';

/* Helper function that logs in and updates app state. */
void login(RootState rootState, String email, String password) async {
  FirebaseUser user;
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    user = await auth.currentUser();
  } catch(e) {
 
    return;
  }
  rootState.setUser(user);
}

void logOut(RootState rootState) {
  rootState.widget.getAuth().signOut();
  rootState.clearUser();
}

void addToShoppingCart(String id) {
  // FirebaseUser user = context.findRootAncestorStateOfType<RootState>().getUser();
  Firestore.instance.collection("user").document(id);
}


String getTheUserID(BuildContext context) {
  RootState root = context.findAncestorStateOfType<RootState>();
  return root.getUser().uid.toString();
}

Future<Map<String, dynamic>> getUserData(String uid) async {
  Firestore store = Firestore.instance;
  CollectionReference collectionRef = store.collection("user");
  DocumentReference userDocument = collectionRef.document(uid);
  DocumentSnapshot snapshot = await userDocument.get();
  return snapshot.data;
}



/*
void setUserIngredient(Ingredient ingredient, String user) {
  Firestore store = Firestore.instance;
  store.document("user").collection("user").document(user).setData();
}
*/