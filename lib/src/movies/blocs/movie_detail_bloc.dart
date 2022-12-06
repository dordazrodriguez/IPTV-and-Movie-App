import 'package:tvapp/src/movies/models/movie_detail_model.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<MovieDetailModel>();

  Stream<MovieDetailModel> get movieDetail => _moviesFetcher.stream;

  fetchMovieDetail(String id, String mode) async {
    MovieDetailModel itemModel = await _repository.fetchMovieDetails(id, mode);
    _moviesFetcher.sink.add(itemModel);
  }

  

  dispose() {
    _moviesFetcher.close();
  }
}

final detailBloc = MovieDetailBloc();