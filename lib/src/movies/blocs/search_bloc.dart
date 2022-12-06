
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final _query = PublishSubject<String>();

  Stream<String> get getQuery => _query.stream;

  sendData(String query){
    if(query != ""){
      _query.add(query);
    }
  }


  dispose() {
    _query.close();
  }
}

final searchBloc = SearchBloc();