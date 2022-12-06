import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:m3u/m3u.dart';
import 'package:tvapp/src/movies/blocs/live_tv_bloc.dart';
import 'package:tvapp/src/movies/movies.dart';
import 'package:tvapp/src/movies/ui/live_tv_ui.dart';
import 'package:tvapp/widgets/create_Drawer.dart';
import 'package:tvapp/widgets/testing.dart';
import 'package:tvapp/const.dart';
import '../../size_config.dart';
import 'ui/search_page.dart';

class LiveTV extends StatefulWidget {
  final VoidCallback load;
  final Stream bloc;

  LiveTV({@required this.load, @required this.bloc});

  @override
  _LiveTVState createState() => _LiveTVState();
}

class _LiveTVState extends State<LiveTV> {
  String url = M3U_URL;

  Widget play = Text("Loading TV...");

  String link;

  List<M3uGenericEntry> _list = new List();

  @override
  void initState() {
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    widget.load();
    super.initState();
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitUp, DeviceOrientation.landscapeRight]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('entered');
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: StreamBuilder<List<M3uGenericEntry>>(
          stream: widget.bloc,
          builder: (context, AsyncSnapshot<List<M3uGenericEntry>> snapshot) {
            print('second');
            if (snapshot.hasData) {
              print("has Data");
              if (snapshot.data.isEmpty) {
                return Scaffold(
                  body: Center(
                    child: Text("No Data"),
                  ),
                );
              } else {
                _list.addAll(snapshot.data);
                print(_list);
                return LiveTVUI(list: _list);
              }
            } else {
              print('third');
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  // user defined function

}
