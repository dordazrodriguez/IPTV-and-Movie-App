
import 'package:rxdart/rxdart.dart';
import 'package:tvapp/src/movies/models/tv_seasons.dart';
import 'package:tvapp/src/movies/resources/repository.dart';

class SeasonDetailBloc {
  final _repository = Repository();
  final _season = PublishSubject<Seasons>();

  Stream<Seasons> get movieDetail => _season.stream;

  fetchSeasonDetail(int id, int number) async {
    Seasons itemModel = await _repository.fetchSeasonDetails(id, number);
    _season.sink.add(itemModel);
  }

  

  dispose() {
    _season.close();
  }
}

final seasonBloc = SeasonDetailBloc();