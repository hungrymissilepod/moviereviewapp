/// For additional Movie information. Used when user select a MoviePoster
// TODO: comment this class to explain what it is for and each property
// TODO: use unit testing to ensure this class parses JSON correctly
class MovieInfo {

  MovieInfo({
    this.id,
    this.title,
    this.overview,
    this.voteAverage,
    this.posterUri,
    this.backdropUri,
    this.genres,
    this.releaseDate,
    this.runtime,
  });

  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final String posterUri;
  
  /// Background image
  final String backdropUri;

  final List<Genre> genres;

  final String releaseDate;

  final int runtime;


  factory MovieInfo.fromJSON(Map data) {
    return MovieInfo(
      id: data['id'] as int ?? 0,
      title: data['title'] as String ?? '',
      overview: data['overview'] as String ?? '',
      voteAverage: data["vote_average"] is int ? (data['vote_average'] as int).toDouble() : data['vote_average'],
      posterUri: data['poster_path'] as String ?? '',
      backdropUri: data['backdrop_path'] as String ?? '',
      releaseDate: data['release_date'] as String ?? '',
      runtime: data['runtime'] as int ?? 0,
      genres: (data['genres'] as List)?.map((e) => e == null ? null : Genre.fromJSON(e as Map<String, dynamic>))?.toList(),
    );
  }
}

// TODO: comment this class
class Genre {

  Genre({ this.id, this.name });

  final int id;
  final String name;

  factory Genre.fromJSON(Map data) {
    return Genre(
      id: data['id'] as int ?? 0,
      name: data['name'] as String ?? '',
    );
  }
}