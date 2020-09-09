
class Genres {
  List<Genre> genres = List();

  Genres.fromJsonList(List<dynamic> jsonList) {

    if (jsonList == null) return;
    genres.addAll(jsonList.map((json) => Genre.fromJson(json)));
  }
}

class Genre {
  int id;
  String name;

  Genre({
    this.id,
    this.name
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    id: json['id'],
    name: json['name']
  );
}