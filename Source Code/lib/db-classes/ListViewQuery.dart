// Cloud Firestore API reference
// https://pub.dev/documentation/cloud_firestore/latest/
// https://pub.dev/documentation/cloud_firestore/latest/cloud_firestore/CollectionReference-class.html

// An abstraction of list view items.
// All items (ingredient or dish) will have a name, description, and two thumnbails.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class ListViewQuery extends StatelessWidget {
  // Think of snapshot as an instance of a database query,
  // That is maintained in real time.
  StreamBuilder<QuerySnapshot> _buildListView(BuildContext context, String collectionName) {
    return StreamBuilder<QuerySnapshot> (
      stream: Firestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        // Function which will build our list, based on the current snapshot.
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _getList(context, snapshot.data.documents);
      }
    );
  }

  // function returns a ListView--a dynamically
  // generated list of items.
  ListView _getList(BuildContext context, List<DocumentSnapshot> snapshot) {
      return ListView(
        children: snapshot.map((data) => _buildSingleItem(context, data)).toList()
      );
    }

  Widget _buildSingleItem(BuildContext context, DocumentSnapshot item);

  @override 
  Widget build(BuildContext context) {
    return _buildListView(context, collectionName);
  }

  final String collectionName;
  ListViewQuery(this.collectionName);

}