import 'package:moviereviewapp/models/movie_model.dart';

class User {
  User({ this.id, this.username, this.location, this.watchlist, this.bio, this.imageUrl });

  final String id;
  final String username;
  final String location;
  final List<int> watchlist;
  final String bio;
  final String imageUrl;

  List<Movie> movies;

  factory User.fromJson(Map data) {
    try {
      return User(
      id: data['id'] as String ?? '',
      username: data['username'] as String ?? '',
      location: data['location'] as String ?? '',
      watchlist: (data['watchlist'] as List)?.map((e) => e as int)?.toList(),
      bio: data['bio'] as String ?? '',
      imageUrl: data['imageUrl'] as String ?? '',
    );
    } catch (e) { /// error with parsing from json
      return null;
    }
  }
}