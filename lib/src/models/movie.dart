
class Movies {

  List<Movie> items = List();

  Movies();

  Movies.fromJsonList(List<dynamic> jsonList) {
    
    if (jsonList == null) return;
    items.addAll(jsonList.map((json) => Movie.fromJson(json)));
  }
}

class Movie {
  
  String uniqueId;
  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  DateTime releaseDate;
  
  Movie({
      this.popularity,
      this.voteCount,
      this.video,
      this.posterPath,
      this.id,
      this.adult,
      this.backdropPath,
      this.originalLanguage,
      this.originalTitle,
      this.genreIds,
      this.title,
      this.voteAverage,
      this.overview,
      this.releaseDate,
      this.uniqueId
  });


  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
      popularity       : json["popularity"] / 1,
      voteCount        : json["vote_count"],
      video            : json["video"],
      posterPath       : json["poster_path"],
      id               : json["id"],
      adult            : json["adult"],
      backdropPath     : json["backdrop_path"],
      originalLanguage : json["original_language"],
      originalTitle    : json["original_title"],
      genreIds         : List<int>.from(json["genre_ids"].map((x) => x)),
      title            : json["title"],
      voteAverage      : json["vote_average"] / 1,
      overview         : json["overview"],
      releaseDate      : DateTime.parse(json["release_date"]),
  );

  Map<String, dynamic> toJson() => {
      "popularity": popularity,
      "vote_count": voteCount,
      "video": video,
      "poster_path": posterPath,
      "id": id,
      "adult": adult,
      "backdrop_path": backdropPath,
      "original_language": originalLanguage,
      "original_title": originalTitle,
      "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
      "title": title,
      "vote_average": voteAverage,
      "overview": overview,
      "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
  };

  String getPosterPath() {
    if (posterPath == null) {
      return 'https://thumbs.dreamstime.com/b/no-image-available-icon-photo-camera-flat-vector-illustration-132483097.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w300$posterPath';
    }
  }

  String getBackdropPath() {
    if (posterPath == null) {
      return 'https://thumbs.dreamstime.com/b/no-image-available-icon-photo-camera-flat-vector-illustration-132483097.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }
  }

  String getSimpleDate() {
    return "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}";
  }
}
