import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FieldStepsStream extends StatelessWidget {
  final DocumentReference _docRef;
  final String _fieldName;
  FieldStepsStream(this._docRef, this._fieldName);
  @override 
  build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot> (
      // Links to a snapshot of a particular document
      stream: _docRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        // The outer build returns the ListView.
        return SizedBox(
          height: 800,
          child: ListView(
          children: snapshot.data[_fieldName].asMap().entries.map<Widget>((item) => 
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              child: Text(
            ((item.key + 1).toString() + ": " + item.value),
            textAlign: TextAlign.left
            )))).toList()
        ));
      }
   );
      }  
}

