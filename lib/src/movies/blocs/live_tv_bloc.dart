
import 'package:rxdart/rxdart.dart';
import 'package:tvapp/src/movies/resources/repository.dart';
import 'package:m3u/m3u.dart';

class LiveTVBloc {
  final _repository = Repository();
  final _live = PublishSubject<List<M3uGenericEntry>>();

  Stream<List<M3uGenericEntry>> get liveTV => _live.stream;

  fetchLiveTV(String url) async {
    String itemModel = await _repository.fetchLiveTVData(url);
    List<M3uGenericEntry> item = await parseToM3u(itemModel);
    _live.sink.add(item);
  }

  Future<List<M3uGenericEntry>> parseToM3u(String data) async {
    List<M3uGenericEntry> item = await parseFile(data);
    return item;
  }

  Future<List<M3uGenericEntry>> searchChannel(String query, String url) async {
    String itemModel = await _repository.fetchLiveTVData(url);
    List<M3uGenericEntry> item = await parseToM3u(itemModel);
    List<M3uGenericEntry> itemSearched = List();
    item.forEach((element) { 
      // print(element.title);
      if(element.title.toLowerCase().contains(query.toLowerCase())){
        itemSearched.add(element);
      }
    });
    // print(itemSearched);
    _live.sink.add(itemSearched);
  }

  dispose() {
    _live.close();
  }
}

final liveTVBloc = LiveTVBloc();