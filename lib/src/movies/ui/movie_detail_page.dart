import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvapp/src/movies/blocs/data_bloc.dart';
import 'package:tvapp/src/movies/blocs/movie_detail_bloc.dart';
import 'package:tvapp/src/movies/models/movie_detail_model.dart';
import 'package:tvapp/src/movies/models/movie_id_model.dart';
import 'package:tvapp/src/movies/ui/overview_details.dart';
import 'package:tvapp/src/movies/ui/tv_season_page.dart';
import 'package:tvapp/widgets/grid_view.dart';
import '../../../size_config.dart';
import 'data_visualizer.dart';

class MovieDetail extends StatefulWidget {
  final int id;
  final String mode;

  MovieDetail({this.id, this.mode});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  int page = 0;
  UniqueKey key = UniqueKey();
  MovieIDModel gm;

  @override
  void initState() {
    detailBloc.fetchMovieDetail(widget.id.toString(), widget.mode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: Scaffold(
        body: StreamBuilder(
          stream: detailBloc.movieDetail,
          builder: (context, AsyncSnapshot<MovieDetailModel> snapshot) {
            if (snapshot.hasData) {
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

  Widget pageBuilder(AsyncSnapshot<MovieDetailModel> snapshot) {
    return DefaultTabController(
      length: widget.mode == 'tv' ? 3 : 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  actions: [
                    IconButton(
                        icon: Icon(snapshot.data.isFavorited
                            ? Icons.star
                            : Icons.star_outline),
                        onPressed: () {})
                  ],
                  expandedHeight: 30 *
                      SizeConfig
                          .heightMultiplier, //MediaQuery.of(context).size.height * .60,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      title: Center(
                        child: Container(
                          //width: SizeConfig.widthMultiplier * 50,
                          child: Center(
                            child: Wrap(children: [
                              Text('',
                                  //widget.mode == 'tv' ? snapshot.data.name : snapshot.data.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            .030,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ]),
                          ),
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/original${snapshot.data.posterPath}')),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            snapshot.data.videos.results.forEach((f) {
                              if (f.type == 'Trailer') {
                                //_launchURL(f.key);
                              }
                            });
                          },
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[],
                            ),
                          ),
                        ),
                      )),
                  bottom: widget.mode == 'tv' ? tvTabs() : movieTabs(),
                ),
              ),
            ),
          ];
        },
        body:
            widget.mode == 'tv' ? tvTabBody(snapshot) : movieTabBody(snapshot),
      ),
      /*   child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
        },
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Container(
                width: SizeConfig.widthMultiplier * 50,
                child: Center(
                  child: Text(
                      widget.mode == 'tv'
                          ? snapshot.data.name
                          : snapshot.data.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            bottom: widget.mode == 'tv' ? tvTabs() : movieTabs(),
          ),
          body: widget.mode == 'tv'
              ? tvTabBody(snapshot)
              : movieTabBody(snapshot),
        ),
      ), */
    );
  }

  Widget movieTabBody(AsyncSnapshot<MovieDetailModel> snapshot) {
    String key = "";
    snapshot.data.videos.results.forEach((f) {
      if (f.type == 'Trailer') {
        key = f.key;
      }
    });
    return TabBarView(
      children: <Widget>[
        Overview(
          myKey: key,
          snapshot: snapshot,
          mode: widget.mode,
        ),
        DataVisualizer(
          load: () {
            page += 1;
            bloc.fetchRecommendation(
                widget.id.toString(), page.toString(), widget.mode);
          },
          bloc: bloc.popularMovies,
          mode: widget.mode,
        ),
      ],
    );
  }

  Widget tvTabBody(AsyncSnapshot<MovieDetailModel> snapshot) {
    return TabBarView(
      children: <Widget>[
        Overview(
          snapshot: snapshot,
          mode: widget.mode,
        ),
        CustomGridView(
          resultList: snapshot.data.seasons,
          onTap: (int i) {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => TVSeasonPage(
                          id: widget.id,
                          number: snapshot.data.seasons[i].seasonNumber,
                          episodecount: snapshot.data.seasons[i].episodeCount,
                          name: snapshot.data.name,
                          seasonTitle: snapshot.data.seasons[i].title,
                          releaseDate: snapshot.data.seasons[i].releaseDate,
                        )));
          },
          onLoad: () {},
        ),
        DataVisualizer(
          load: () {
            page += 1;
            bloc.fetchRecommendation(
                widget.id.toString(), page.toString(), widget.mode);
          },
          bloc: bloc.popularMovies,
          mode: widget.mode,
        ),
      ],
    );
  }

  Widget movieTabs() {
    return TabBar(
      tabs: [
        Tab(
          child: Text(
            "Overview",
            style: TextStyle(
                //fontSize: 3 * SizeConfig.textMultiplier,
                ),
          ),
        ),
        Tab(
          child: Text(
            "See also",
            style: TextStyle(
                //fontSize: 3 * SizeConfig.textMultiplier,
                ),
          ),
        ),
      ],
    );
  }

  Widget tvTabs() {
    return TabBar(
      isScrollable: true,
      tabs: [
        Tab(
          child: Text(
            "Overview",
            style: TextStyle(
              fontSize: 3 * SizeConfig.textMultiplier,
            ),
          ),
        ),
        Tab(
          child: Text(
            "Seasons",
            style: TextStyle(
              fontSize: 3 * SizeConfig.textMultiplier,
            ),
          ),
        ),
        Tab(
          child: Text(
            "See also",
            style: TextStyle(
              fontSize: 3 * SizeConfig.textMultiplier,
            ),
          ),
        ),
      ],
    );
  }
}
