
import 'package:rxdart/rxdart.dart';
import 'package:tvapp/src/movies/models/scraped_data_model.dart';
import 'package:tvapp/src/movies/resources/scraping_websites/123_club_scrap.dart';
import 'package:tvapp/src/movies/resources/scraping_websites/imdb_id_scrap.dart';
import 'package:tvapp/src/movies/resources/scraping_websites/scraping.dart';


class ScrapingBloc {
  final _scraping = Scraping();
  final _imdb = ImdbIDScrapper();
  final _clubfiles = ClubMovies();
  final _moviesFetcher = PublishSubject<List<ScrapingModel>>();

  

  Stream<List<ScrapingModel>> get links => _moviesFetcher.stream;

  fetchMovieLinks(String query, String year) async {
    List<ScrapingModel> itemData = List();

    List<String> itemModel1 = await _scraping.getLinks(query, year);
    itemModel1.forEach((element) { 
      itemData.add(getAsNeeded(element));
    });

    String id = await _imdb.getIMDBID(query, year);
    List<String> itemeModel2 = await _clubfiles.getLink(query, year, id);
    itemeModel2.forEach((element) {
      itemData.add(getAsNeeded(element));
    });
    
    _moviesFetcher.sink.add(itemData);
    
  }

  ScrapingModel getAsNeeded(String url){
    if(url.contains("cmovies")){
      String name = "CMoviesHD: " + getQuality(url);
      ScrapingModel scrapingModel = new ScrapingModel(name, url);
      return scrapingModel;
    } else if(url.contains("google")){
      String name = "123Files Club";
      ScrapingModel scrapingModel = new ScrapingModel(name, url);
      return scrapingModel;
    } else {
      String name = "Video Link";
      ScrapingModel scrapingModel = new ScrapingModel(name, url);
      return scrapingModel;
    }
  }

  String getQuality(String data) {
    if (data.contains("720")) {
      return "720p";
    } else if (data.contains("480")) {
      return "480p";
    } else if (data.contains("360")) {
      return "360p";
    } else if (data.contains("1080")) {
      return "1080p";
    } else {
      return "";
    }
  }

  fetchCMoviesHDLinks(String query, String year) async {
    // List<String> itemModel = await _scraping.getLinks(query, year);
    // itemData.addAll(itemModel);
    // _moviesFetcher.sink.add(itemData);
  }

  fetch123FilesClubLinks(String query, String year) async {
    // String id = await _imdb.getIMDBID(query, year);
    // String itemModel = await _clubfiles.getLink(query, year, id);
    // itemData.add(itemModel);
    // _moviesFetcher.sink.add(itemData);
  }

  fetchTVLinks(String query, String year, String season, int episodeNumber) async {
    // List<String> itemModel = await _scraping.getTVLinks(query, year, season, episodeNumber);
    // _moviesFetcher.sink.add(itemModel);
  }

  

  dispose() {
    _moviesFetcher.close();
  }
}

final scrapingBloc = ScrapingBloc();