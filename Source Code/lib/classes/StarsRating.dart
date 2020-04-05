import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarsRating extends StatelessWidget {
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.orange,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
