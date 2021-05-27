class Review {

  Review({ this.id, this.userId, this.movieId, this.title, this.body, this.rating });

  final String id;
  final String userId;
  final int movieId;
  final String title;
  final String body;
  final double rating;

  factory Review.fromJson(Map data) {
    return Review(
      id: data['id'] as String ?? '',
      userId: data['user_id'] as String ?? '',
      movieId: data['movie_id'] as int ?? 0,
      title: data['title'] as String ?? '',
      body: data['body'] as String ?? '',
      rating: data["rating"] is int ? (data['rating'] as int).toDouble() : data['rating'],
    );
  }

  Map<String, dynamic> toMap() =>
  {
    'id': id,
    'user_id': userId,
    'movie_id': movieId,
    'title': title,
    'body': body,
    'rating': rating,
  };
}