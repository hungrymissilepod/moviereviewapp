import 'package:flutter/material.dart';

// TODO: add edit button to tile
// TODO: edit button should take user to form and they should be able to change their review
// TODO: add delete button so user can also delete their review
class UserReviewCard extends StatelessWidget {

  UserReviewCard(this.title, this.body);

  final String title;
  final String body;
  @override
  Widget build(BuildContext context) {
    return Container(
    child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TODO: show user avatar and name
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(
                body,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}