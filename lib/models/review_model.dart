class Review {

  Review({ this.userId, this.movieId, this.title, this.body, this.rating });

  final String userId;
  final int movieId;
  final String title;
  final String body;
  final int rating;

  factory Review.fromJson(Map data) {
    return Review(
      userId: data['user_id'] as String ?? '',
      movieId: data['movie_id'] as int ?? 0,
      title: data['title'] as String ?? '',
      body: data['body'] as String ?? '',
      rating: data['rating'] as int ?? 0,
    );
  }

  Map<String, dynamic> toMap() =>
  {
    'user_id': userId,
    'movie_id': movieId,
    'title': title,
    'body': body,
    'rating': rating,
  };
}