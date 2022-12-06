import 'package:tvapp/src/movies/models/popular_movies.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class DataBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<MoviesModel>();

  Stream<MoviesModel> get popularMovies => _moviesFetcher.stream;

  fetchPopular(String page, String mode) async {
    MoviesModel itemModel = await _repository.fetchPopularMovies(page, mode);
    _moviesFetcher.sink.add(itemModel);
  }

  fetchGenreMovies(String id, String page, String mode) async {
    MoviesModel itemModel = await _repository.fetchMovieGenre(id, page, mode);
    _moviesFetcher.sink.add(itemModel);
  }

  searchMovies(String page, String query, String mode) async {
    MoviesModel itemModel = await _repository.searchMovie(page, query, mode);
    _moviesFetcher.sink.add(itemModel);
  }

  fetchRecommendation(String id, String page, String mode) async {
    MoviesModel itemModel = await _repository.fetchRecommendations(id, page, mode);
    _moviesFetcher.sink.add(itemModel);
  }

  dispose() {
    _moviesFetcher.close();
  }
}

final bloc = DataBloc();