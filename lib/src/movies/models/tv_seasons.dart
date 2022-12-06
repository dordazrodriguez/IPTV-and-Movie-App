class Seasons {
  int episodeCount;
  int id;
  int seasonNumber;
  String posterPath;
  String title;
  String releaseDate;
  List<EpisodesModel> episodes;


  Seasons.fromJson(Map<String, dynamic> json) {
    episodeCount = json['episode_count'];
    id = json['id'];
    seasonNumber = json['season_number'];
    posterPath = json['poster_path'];
    title = json['name'];
    releaseDate = json['air_date'];
    if (json['episodes'] != null) {
      episodes = new List<EpisodesModel>();
      json['episodes'].forEach((v) {
        episodes.add(new EpisodesModel.fromJson(v));
      });
    }
  }

}

class EpisodesModel {
  String name;
  String overview;
  String stillPath;
  double voteAverage;
  String releaseDate;


  EpisodesModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    overview = json['overview'];
    stillPath = json['still_path'];
    releaseDate = json['air_date'];
  }

}