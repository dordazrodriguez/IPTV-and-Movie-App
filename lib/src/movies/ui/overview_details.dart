import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvapp/src/movies/blocs/scraping_bloc.dart';
import 'package:tvapp/src/movies/models/movie_detail_model.dart';
import 'package:tvapp/src/movies/models/movie_id_model.dart';
import 'package:tvapp/src/movies/ui/scraping_page.dart';
import 'package:tvapp/widgets/youtube_player.dart';

import '../../../size_config.dart';

class Overview extends StatefulWidget {
  final AsyncSnapshot<MovieDetailModel> snapshot;
  final String mode;
  final String myKey;

  Overview({this.snapshot, this.mode, this.myKey});

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  List<String> _list = new List();
  List<MovieIDModel> gm;
  String id;
  String trailer = "Play Trailer";

  @override
  void initState() {
    super.initState();
    gm = new List();
    widget.snapshot.data.genres.forEach((f) {
      _list.add(f.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              /* decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500${widget.snapshot.data.posterPath}"),
                      fit: BoxFit.cover)),   */
              child: Column(
                children: <Widget>[
                  /* SliverAppBar(
                    title: Text('kjdnk'),
                    floating: true,
                    expandedHeight: 200,
                  ),  */
                  /* Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .3,
                      width: MediaQuery.of(context).size.width * .15,
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w500${widget.snapshot.data.posterPath}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),  */
                  SizedBox(
                    height: 3 * SizeConfig.heightMultiplier,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.mode == 'tv'
                              ? widget.snapshot.data.name
                              : widget.snapshot.data.title,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * .03,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          child: Text(trailer),
                          onPressed: () {
                            if (widget.myKey != "") {
                              // _launchURL(widget.myKey);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          YoutubePlayerPage(widget.myKey)));
                            } else {
                              setState(() {
                                trailer = "No Trailer Found!";
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3 * SizeConfig.heightMultiplier,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Popularity: " +
                              widget.snapshot.data.voteAverage.toString(),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .02,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.mode == 'tv'
                              ? "Episode Time: " +
                                  widget.snapshot.data.episodetime[0]
                                      .toString() +
                                  " Min."
                              : "Time: " +
                                  widget.snapshot.data.runtime.toString() +
                                  " Min.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .02,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3 * SizeConfig.heightMultiplier,
                  ),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Genres: " + _list.join("/"),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .02,
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Released:  " + widget.snapshot.data.releaseDate,
                          style: TextStyle(
                            //color: Colors.deepOrangeAccent,
                            fontSize: MediaQuery.of(context).size.width * .02,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3 * SizeConfig.heightMultiplier,
                  ),
                  Text(
                    widget.snapshot.data.overview == null
                        ? "Overview"
                        : widget.snapshot.data.overview,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),
                  ),
                  SizedBox(
                    height: 3 * SizeConfig.heightMultiplier,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: widget.mode == 'tv' ? false : true,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ScrapingPage(
                            query: widget.snapshot.data.title.toLowerCase(),
                            load: () {
                              scrapingBloc.fetchMovieLinks(
                                  widget.snapshot.data.title.toLowerCase(),
                                  widget.snapshot.data.releaseDate
                                      .substring(0, 4));
                            },
                            bloc: scrapingBloc.links,
                          )));
            },
            child: Icon(Icons.play_arrow),
          ),
        ),
      ),
    );
  }

  // _launchURL(String key) async {
  //   String url = 'https://www.youtube.com/watch?v=$key';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

}
