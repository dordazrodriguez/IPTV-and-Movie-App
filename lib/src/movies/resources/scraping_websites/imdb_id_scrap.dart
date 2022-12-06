import 'package:tvapp/src/movies/models/imdb_id.dart';
import 'package:tvapp/src/movies/network/api_provider.dart';

class ImdbIDScrapper{

  ApiProvider apiProvider = new ApiProvider();


  Future<IMDBIDModel> getIMDBIDList(String query) async{

    String alpha = getFirstAlphabet(query);

    query = query.replaceAll(" ", "_");
  
    String url = "https://v2.sg.media-imdb.com/suggestion/$alpha/$query.json";
  
    return apiProvider.get(url).then((dynamic res) {
      return IMDBIDModel.fromJson(res);
    });
  
    }
  
    String getFirstAlphabet(String query) {
      return query[0];
    }

    Future<String> getIMDBID(String query, String year) async{

      query = query.replaceAll("()", "");
      print(query);

      IMDBIDModel imdbidModel = await getIMDBIDList(query);
      List list = imdbidModel.d;
      List<String> id = List();
      list.forEach((element) {
        if(element.l.toString().toLowerCase() == query.toLowerCase() && element.q != "TV series" && element.y.toString() == year){
          id.add(element.id);
        }
      });
      return id[0] ?? "";
    }


}