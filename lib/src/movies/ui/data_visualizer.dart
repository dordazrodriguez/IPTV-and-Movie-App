import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvapp/src/movies/models/popular_movies.dart';
import 'package:tvapp/widgets/grid_view.dart';

import 'movie_detail_page.dart';

class DataVisualizer extends StatefulWidget {
  final VoidCallback load;
  final Stream<dynamic> bloc;
  final UniqueKey mykey;
  final String mode;

  DataVisualizer({this.load, this.bloc, this.mykey, this.mode});

  @override
  _DataVisualizerState createState() => _DataVisualizerState();
}

class _DataVisualizerState extends State<DataVisualizer> {
  List<Results> _list;

  int page = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _list.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _list = [];
    widget.load();
    widget.load();
    return StreamBuilder(
      key: widget.mykey,
      stream: widget.bloc,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          _list.addAll(snapshot.data.results);
          return Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
            },
            child: CustomGridView(
              resultList: _list,
              onTap: (int i) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            MovieDetail(id: _list[i].id, mode: widget.mode)));
              },
              onLoad: () {
                widget.load();
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
