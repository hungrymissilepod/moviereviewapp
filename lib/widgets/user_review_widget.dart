import 'package:flutter/material.dart';

class UserReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
    child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: show user avatar and name
              Text(
                'title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'body odfkodfko ksdks jdssdjsdj  ek  efkdjfdj f d s kjsdkjs kjk ji ji jidjwdj j iji ',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}