import 'genre_model.dart';
import 'tv_seasons.dart';

class MovieDetailModel {
  List<Genres> genres;
  int id;
  String overview;
  String posterPath;
  String releaseDate;
  int runtime;
  String title;
  double voteAverage;
  List<Seasons> seasons;
  Videos videos;
  List episodetime;
  String name;
  bool isFavorited;

  MovieDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    overview = json['overview'];
    voteAverage = json['vote_average'];
    posterPath = json['poster_path'];
    episodetime = json['episode_run_time'];
    name = json['name'];
    isFavorited = false;
    if (json['seasons'] != null) {
      seasons = new List<Seasons>();
      json['seasons'].forEach((v) {
        seasons.add(new Seasons.fromJson(v));
      });
    }
    if (json['genres'] != null) {
      genres = new List<Genres>();
      json['genres'].forEach((v) {
        genres.add(new Genres.fromJson(v));
      });
    }
    releaseDate = json['release_date'];
    runtime = json['runtime'];
    title = json['title'];
    videos =
        json['videos'] != null ? new Videos.fromJson(json['videos']) : null;
  }
}

class Videos {
  List<Results> results;

  Videos.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }
}

class Results {
  String key;
  String type;

  Results.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    type = json['type'];
  }
}
