import 'package:html/parser.dart';
import 'package:tvapp/src/movies/network/api_provider.dart';

class ClubMovies {
  ApiProvider apiProvider = new ApiProvider();

  Future<List<String>> getLink(String query, String year, String id) async {

    query = query.replaceAll(" ", "%20");

    String url =
        "https://123files.club/download/movie/?id=$id&name=&query&year=$year";

    var map = new Map<String, dynamic>();

    map['imdb'] = id;
    map['imdbGO'] = '';

    return apiProvider.post(url, body: map).then((dynamic res) {
      var myDocument = parse(res);
      var link = myDocument.getElementsByTagName('a');
      List<String> list = List();
      link.forEach((element) {
        if(element.text == 'OPEN GOOGLE LINK'){
          print(element.attributes['href']);
          list.add(element.attributes['href']);
        }
      });
      return list;
    });
    
  }
}
