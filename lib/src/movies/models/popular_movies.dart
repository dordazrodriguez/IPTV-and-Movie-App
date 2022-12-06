class MoviesModel {
  List<Results> results;

  MoviesModel.fromJsonforMovie(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJsonforMovie(v));
      });
    }
  }

  MoviesModel.fromJsonforTV(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJsonforTV(v));
      });
    }
  }
}

class Results {
  int id;
  String posterPath;
  String title;
  String releaseDate;


  Results.fromJsonforMovie(Map<String, dynamic> json) {
    id = json['id'];
    posterPath = json['poster_path'];
    title = json['title'];
    releaseDate = json['release_date'];
  }

  Results.fromJsonforTV(Map<String, dynamic> json) {
    id = json['id'];
    posterPath = json['poster_path'];
    title = json['name'];
    releaseDate = json['first_air_date'];
  }
}