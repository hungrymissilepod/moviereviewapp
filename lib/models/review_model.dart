class Review {

  Review({ this.userId, this.title, this.body, this.rating });

  final String userId;
  final String title;
  final String body;
  final int rating;

  factory Review.fromJson(Map data) {
    return Review(
      userId: data['user_id'] as String ?? '',
      title: data['title'] as String ?? '',
      body: data['body'] as String ?? '',
      rating: data['rating'] as int ?? 0,
    );
  }
}