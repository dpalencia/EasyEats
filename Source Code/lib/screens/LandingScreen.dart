import 'package:flutter/material.dart';
import 'package:odysseusrecipes/classes/MainDrawer.dart';
import 'package:odysseusrecipes/classes/Theme.dart';
import 'package:odysseusrecipes/screens/IngredientsList.dart';
import 'package:odysseusrecipes/screens/DishesList.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* IMPORTANT: Wrap the landing screen in a MaterialApp widget
      Because we want the navigator to be nested underneath the "Root" state
      otherwise child widgets will not find the state.
      The Landing Screen begins at the bottom of the navigator stack.
    */
    return MaterialApp(
      theme: darkTheme(),
      home: Scaffold (
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(
              "assets/eewhite.png",
              height: 100
             ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: (){
                showSearch(context: context, delegate: MainSearch()
                );
              },
            ),
          ],
        ),
        drawer: MainDrawer(),
        body: MainScreen(),
        backgroundColor: Theme.of(context).backgroundColor,
    )
  );  
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:  <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Image.network('https://firebasestorage.googleapis.com/v0/b/odysseus-recipes.appspot.com/o/Images%2Flanding.jpg?alt=media&token=6bc75697-d49a-4dd5-b70d-63a1b8241e5a'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Theme.of(context).accentColor,
            child: FlatButton(
              child: ListTile(
                leading: Icon(
                  Icons.restaurant_menu,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Categories',
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 20.0,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              onPressed: (){
                print('Categories pressed');
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              color: Theme.of(context).accentColor,
              child: FlatButton(
                child: ListTile(
                  leading: Icon(
                    Icons.kitchen,
                    size: 40.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Ingredients',
                    style: TextStyle(
                        fontFamily: 'Caveat',
                        fontSize: 20.0,
                        color: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => IngredientsList()));
                },
              ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Theme.of(context).accentColor,
            child: FlatButton(
              child: ListTile(
                leading: Icon(
                  Icons.restaurant,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Recipes',
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 20.0,
                    color: Theme.of(context).backgroundColor
                  ),
                ),
              ),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DishesList.type("dishes")));
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Theme.of(context).accentColor,
            child: FlatButton(
              child: ListTile(
                leading: Icon(
                  Icons.favorite,
                  size: 40.0,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'Favorites',
                  style: TextStyle(
                    fontFamily: 'Caveat',
                    fontSize: 20.0,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DishesList.type("Favorites")));
                },
            ),
          ),
        ),
      ],
    );
  }
}


class MainSearch extends SearchDelegate<String> {
// hardcoded tokens
  final searches = [
    "Chicken Parmesan",
    "Lasagna",
    "Garlic Butter Potatoes",
    "Pizza",
    "Spaghetti",
    "Caesar Salad",
    "Hot Wings",
    "Garlic Shrimp and White Beans",
    "South West Rice Salad",
    "Egg Caserole",
    "Bacon Avocado Fries",
    "Ravioli",
    "Carne Asada",
    "Tonkotsu Ramen",
    "Sweet and Spicy Ribs",
    "Mexican Steak Torta",
    "Grilled Cheese Fingers",
    "Homemade Salsa",
    "California Rolls",
    "Spicy Tuna Roll",
    "Choclate Chip Cookies",
    "Katsukra Tonkatsu"
  ];

  final recentSearch = [
    "Caesar Salad",
    "Hot Wings",
    "Garlic Shrimp and White Beans",
    "SouthWest Rice Salad",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for appbar -OSCAR
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
          ),
        onPressed: (){
            query = " ";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on left of app bar -OSCAR
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context,null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some results based on selection -OSCAR
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something -OSCAR
    final suggestionList = query.isEmpty?recentSearch:searches.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context,index)=>ListTile(
        onTap: () {
          //show result will lead to dish page searched or clicked on based off token given by user - OSCAR
          //showResults(context); use SHOWRESULT METHOD for populating specific dish Screen - OSCAR
          print('Option Selected');
        },
        leading: Icon(
            Icons.add_circle_outline,
            size: 30.0,
        ),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0,query.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(
                  color: Theme.of(context).textTheme.body1.color,
                ),
              ),
            ]
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}





/*class Home extends StatelessWidget {

  @override build(BuildContext context) { 
    return MaterialApp (
      home: Scaffold(
        drawer: MainDrawer(), 
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
      )
    );
  }
}

*/