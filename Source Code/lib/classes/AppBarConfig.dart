import 'package:flutter/material.dart';

class AppBarConfig extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.red,
          child: AppBar(
            backgroundColor: Colors.orange[400],
            leading: new IconButton(
                icon: backIcon,
                onPressed: null), //change onPressed go to previous screen
            actions: <Widget>[
              userIcon,
              settingsIcon,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

/*                       APPBAR CODE                                      */

var backIcon = Container(
  child: IconButton(
    icon: Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    ),
    onPressed: () {}, // GO BACK
  ),
);

var userIcon = Container(
  child: IconButton(
    icon: Icon(
      Icons.person_outline,
      color: Colors.white,
    ),
    onPressed: () {
      //USER REDIRECT
    },
  ),
);

var settingsIcon = Container(
  child: IconButton(
    icon: Icon(
      Icons.settings,
      color: Colors.white,
    ),
    onPressed: () {
      //SETTINGS REDIRECT
    },
  ),
);

/*                    END APPBAR CODE                                      */
