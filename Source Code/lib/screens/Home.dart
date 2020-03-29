import 'package:flutter/material.dart';
import 'package:odysseusrecipes/functions/UIHelpers.dart';
import 'package:odysseusrecipes/screens/Root.dart';

class Home extends StatelessWidget {


  @override build(BuildContext context) { 
    return Scaffold(
        drawer: mainDrawer(context), 
        backgroundColor: Colors.amber[400],
        appBar: AppBar( 
          title: Text('Recipe App'),
          backgroundColor: Colors.redAccent[700],
        ),
        body: Center(
          child: Image(
            //image: AssetImage('images/diamond.png'),
            image: NetworkImage(
                'https://eatforum.org/content/uploads/2018/05/table_with_food_top_view_900x700.jpg'
              ),
          ),
        ),
    );
  }
}

