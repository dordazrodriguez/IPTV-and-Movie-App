import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:tvapp/src/movies/models/movie_id_model.dart';
import 'package:tvapp/src/movies/network/api_provider.dart';

class Scraping {
  ApiProvider apiProvider = new ApiProvider();
  String id;

  Future<String> getmovieID(String query, String year) {
    query = query.replaceAll(" ", "%20");
    print(query);
    String url =
        'https://cmovieshd.is/?c=movie&m=filter2&page=1&position=0&order_by=&keyword=$query&date=&quality=&res=&genre=&directors=&cast=&subtitles=&country=&year=$year&yrf=&yrt=&rating=&votes=&language=&lang=';
    Map<String, String> header = {
      'authority': 'cmovieshd.is',
      'method': 'GET',
      // 'referer': 'https://cmovieshd.is/',
      HttpHeaders.refererHeader : 'https://cmovieshd.is/',
      'path':
          '/?c=movie&m=quickSearch&key=4164OPTZ98adf546874s4&keyword=$query',
      'x-requested-with': 'XMLHttpRequest',
      'cookie': '_ga=GA1.2.1559077571.1585938238; _gid=GA1.2.1407262217.1587277654; _gat=1; approve_search=yes',
    };
    print(url);
    return apiProvider.getWithHeader(url, header).then((dynamic res) {
      var document = parse(res);
      if(document.getElementsByClassName("clip-link").isEmpty){
        return "";
      }
      var links = document.getElementsByClassName("clip-link");
      String link = "";
      links.forEach((element) {
        link = element.attributes['data-id'];
      });
      print(link);
      return link;
    });
  }

  

  Future<dynamic> getHtmlContent(String url) {
    return apiProvider.getHtml(url).then((dynamic res) {
      return res.toString();
    });
  }

  Future<List<String>> getLinks(String query, String year) async {
    String id = await getmovieID(query, year);
    String url = 'https://cmovieshd.is/bloodshot-stream-$id.html';
    if(url == ""){
      return [];
    }
    var document = await getHtmlContent(url);
    var mydocument = parse(document);
    var links = mydocument.getElementsByClassName('streams');
    List<String> _list = new List();
    links.forEach((f) {
      if (f.text.contains("VIP")  && !f.text.contains("Compatible with Android / iPhone")) {
        _list.add("https:" + f.attributes['href']);
      }
    });
    return _list;
  }

  Future<List<String>> getTVLinks(String query, String year,
      String seasonNumber, int episodNumber) async {
    String id = await getmovieID(query + " - " + seasonNumber, year);
    // km.forEach((f) {
    //   print(f.title);
    //   if (f.title.contains(seasonNumber)) {
    //     print("1");
    //       id = f.id;
    //   }
    // });
    episodNumber += 1;
    String url = 'https://cmovieshd.is/game-of-thrones-season-4-episode-$episodNumber-stream-$id.html';
    print(url);
    var document = await getHtmlContent(url);
    var mydocument = parse(document);
    var links = mydocument.getElementsByClassName('streams');
    List<String> _list = new List();
    links.forEach((f){
      if(f.text.contains("VIP") && !f.text.contains("Compatible with Android / iPhone")){
          _list.add("https:"+f.attributes['href']);
      }
    });
    return _list;
  }
}
