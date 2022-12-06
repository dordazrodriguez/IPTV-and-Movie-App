import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvapp/src/movies/blocs/scraping_bloc.dart';
import 'package:tvapp/src/movies/blocs/tv_seasons_bloc.dart';
import 'package:tvapp/src/movies/models/tv_seasons.dart';
import 'package:tvapp/src/movies/ui/scraping_page.dart';

import '../../../size_config.dart';

class TVSeasonPage extends StatefulWidget {
  final int id;
  final String name;
  final int number;
  final String releaseDate;
  final int episodecount;
  final String seasonTitle;

  TVSeasonPage(
      {this.id,
      this.number,
      this.name,
      this.releaseDate,
      this.episodecount,
      this.seasonTitle});

  @override
  _TVSeasonPageState createState() => _TVSeasonPageState();
}

class _TVSeasonPageState extends State<TVSeasonPage>
    with TickerProviderStateMixin {
  Seasons gm;
  List<Tab> _tabs = List<Tab>();
  List<Widget> _generalWidgets = List<Widget>();
  TabController _tabController;

  @override
  void initState() {
    seasonBloc.fetchSeasonDetail(widget.id, widget.number);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> getTabs(int count) {
    _tabs.clear();
    for (int i = 1; i < count + 1; i++) {
      _tabs.add(getTab(i));
    }
    return _tabs;
  }

  TabController getTabController(int count) {
    return TabController(length: count, vsync: this);
  }

  Widget getTab(int widgetNumber) {
    return Tab(
      child: Text("Episode $widgetNumber"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: Scaffold(
        body: StreamBuilder(
          stream: seasonBloc.movieDetail,
          builder: (context, AsyncSnapshot<Seasons> snapshot) {
            if (snapshot.hasData) {
              _tabController = getTabController(snapshot.data.episodes.length);
              _tabs = getTabs(snapshot.data.episodes.length);
              return pageBuilder(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget pageBuilder(AsyncSnapshot<Seasons> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Season " + widget.number.toString()),
        bottom: TabBar(
          isScrollable: true,
          tabs: _tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: getWidgets(snapshot),
      ),
    );
  }

  Widget getTabBody(AsyncSnapshot<Seasons> snapshot, int i) {
    String url = "https://dummyimage.com/16:9x1080/";
    if (snapshot.data.episodes[i].stillPath != null) {
      url =
          'https://image.tmdb.org/t/p/w500${snapshot.data.episodes[i].stillPath}';
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => ScrapingPage(
                        query: snapshot.data.episodes[i].name.toLowerCase(),
                        load: () {
                          scrapingBloc.fetchTVLinks(
                            widget.name.toLowerCase(),
                            widget.releaseDate.substring(0, 4),
                            "Season " + widget.number.toString(),
                            i,
                          );
                        },
                        bloc: scrapingBloc.links,
                      )));
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    snapshot.data.episodes[i].name,
                    style: TextStyle(
                      fontSize: 3 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .80,
                height: MediaQuery.of(context).size.height * .40,
                child: Image.network(url),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    height: MediaQuery.of(context).size.height * .80,
                    child: Text(
                      snapshot.data.episodes[i].overview,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getWidgets(AsyncSnapshot<Seasons> snapshot) {
    _generalWidgets.clear();
    for (int i = 0; i < snapshot.data.episodes.length; i++) {
      print(i);
      _generalWidgets.add(getTabBody(snapshot, i));
    }
    return _generalWidgets;
  }
}
