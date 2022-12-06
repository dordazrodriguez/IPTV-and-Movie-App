
class MovieIDModel {
  String id;
  String year;
  String title;

  MovieIDModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    year = json['year'];
    title = json['title'];
  }
}