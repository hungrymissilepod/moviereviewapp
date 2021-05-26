class User {
  User({ this.id, this.username, this.location, this.watchlist });

  final String id;
  final String username;
  final String location;
  final List<int> watchlist;

  factory User.fromJson(Map data) {
    return User(
      id: data['id'] as String ?? '',
      username: data['username'] as String ?? '',
      location: data['location'] as String ?? '',
      watchlist: (data['watchlist'] as List)?.map((e) => e as int)?.toList(),
    );
  }
}