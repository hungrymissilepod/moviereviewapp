class Movie {
  Movie({ this.id, this.title, this.overview, this.voteAverage, this.imageUrl });

  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final String imageUrl;

  /// Convert JSON to Movie object
  factory Movie.fromJson(Map data) {
    return Movie(
      id: data['id'] as int ?? 0,
      title: data['title'] as String ?? '',
      overview: data['overview'] as String ?? '',
      voteAverage: data["vote_average"] is int ? (data['vote_average'] as int).toDouble() : data['vote_average'],
      imageUrl: data['poster_path'] as String ?? '',
    );
  }
}