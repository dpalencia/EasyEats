import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/AppBarConfig.dart';
import 'package:odysseusrecipes/classes/StarsRating.dart';


class SingleDish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: heartButton,
        drawer: Drawer(),
        appBar: AppBarConfig(),
        body: Column(
          children: <Widget>[
            FittedBox(
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/odysseus-recipes.appspot.com/o/Images%2FwheatBread.jpg?alt=media&token=7eba1572-81b5-4d13-ab52-6e6dbdd10c3b'
                ),
                fit: BoxFit.fill, // demo, replace with what user clicked on.
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                prepIcon,
                cookIcon,
                diffIcon,
              ],
            ),
            Column(
              children: <Widget>[
                name,
                StarsRating(),
                ingredients,
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*                  FUNCTIONS & VARIABLES BELOW                            */

var name = Container(
  child: Text(
    'Salmon Egg Salad', // replace with actual name of dish
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
    ),
  ),
);

var ingredients = Container(
  child: Text(
      '*Wild salmon fillet for 1 to 6 servings salt and pepper \n* Salt and ground pepper \n* Yadayadayadayada'),
);

var prepIcon = Container(
  child: Column(
    children: <Widget>[Icon(Icons.restaurant), Text('Prep Time:\n25 Min')],
  ),
);

var cookIcon = Container(
  child: Column(
    children: <Widget>[Icon(Icons.timer), Text('Cook Time:\n15 Min')],
  ),
);

var diffIcon = Container(
    child: Column(
  children: <Widget>[
    Icon(Icons.accessibility),
    Text('Difficulty Level:\nBeginner')
  ],
));

var heartButton = Container(
  child: FloatingActionButton(
    backgroundColor: Colors.orange[400],
    child: Icon(
      Icons.favorite,
      color: Colors.white,
    ),
    onPressed: null,
  ),
);
