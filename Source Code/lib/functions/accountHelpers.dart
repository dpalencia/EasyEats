import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:odysseusrecipes/screens/Root.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Helper function that logs in and updates app state. */
void login(RootState rootState, String email, String password) async {
  FirebaseUser user;
  try {
    await rootState.widget.getAuth().signInWithEmailAndPassword(email: email, password: password);
    user = await rootState.widget.getAuth().currentUser();
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