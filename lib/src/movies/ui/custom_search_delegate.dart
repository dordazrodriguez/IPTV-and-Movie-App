import 'package:flutter/material.dart';
import 'package:tvapp/src/movies/blocs/data_bloc.dart';

import 'data_visualizer.dart';

class CustomSearchDelegate extends SearchDelegate {


  final String mode;
  final FocusNode _node = FocusNode();



  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  CustomSearchDelegate({this.mode});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        focusNode: _node,
          icon: Icon(Icons.close),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      focusNode: _node,
        icon: Icon(Icons.arrow_back),
        onPressed: () {
    close(context, null);
        },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    int page = 0;
    return DataVisualizer(
        load: () {
      page += 1;
      bloc.searchMovies(page.toString(), query, this.mode);
        },
        bloc: bloc.popularMovies,
        mode: this.mode,
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  
}
