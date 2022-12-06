import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvapp/size_config.dart';
import 'package:tvapp/src/movies/blocs/data_bloc.dart';
import 'package:tvapp/src/movies/live_tv.dart';
import 'package:tvapp/src/movies/models/genre_model.dart';
import 'package:tvapp/src/movies/resources/repository.dart';
import 'package:tvapp/src/movies/ui/data_visualizer.dart';
import 'package:tvapp/src/movies/ui/search_page.dart';
import 'package:tvapp/widgets/create_Drawer.dart';
import 'package:tvapp/widgets/testing.dart';
import './ui/custom_search_delegate.dart';
import 'blocs/live_tv_bloc.dart';
import 'package:tvapp/const.dart';

class Movies extends StatefulWidget {
  final String mode;

  Movies({this.mode});

  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  GenreModel gm;
  List<Genres> _list = new List();
  bool isLoaded = false;
  static int page = 0;
  static String mode;

  Genres _selectedLocation = new Genres();
  Widget tab;

  void fLoad() {
    tab = Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: DataVisualizer(
        load: () {
          page += 1;
          bloc.fetchPopular(page.toString(), mode);
        },
        bloc: bloc.popularMovies,
        mykey: UniqueKey(),
        mode: mode,
      ),
    );
  }

  @override
  void initState() {
    mode = widget.mode;
    fLoad();
    getgenre();
    Genres km = new Genres(name: "Most Popular", id: 0);
    _list.add(km);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoaded
            ? DropdownButtonHideUnderline(
                child: new DropdownButton<Genres>(
                    items: _list.map((Genres val) {
                      return DropdownMenuItem<Genres>(
                        value: val,
                        child: new Text(
                          val.name != null ? val.name : "Most Popular",
                          style: TextStyle(
                            color: Colors.white,
                            //fontSize: 3 * SizeConfig.textMultiplier,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      _selectedLocation.name != null
                          ? _selectedLocation.name
                          : "Most Popular",
                      style: TextStyle(
                        color: Colors.white,
                        //fontSize: 3 * SizeConfig.textMultiplier,
                      ),
                    ),
                    onChanged: (Genres val) {
                      _selectedLocation = val;
                      setState(() {
                        if (val.id == 0) {
                          tab = DataVisualizer(
                            load: () {
                              page += 1;
                              bloc.fetchPopular(page.toString(), mode);
                            },
                            bloc: bloc.popularMovies,
                            mykey: UniqueKey(),
                            mode: mode,
                          );
                        } else {
                          tab = DataVisualizer(
                            load: () {
                              page += 1;
                              bloc.fetchGenreMovies(
                                  val.id.toString(), page.toString(), mode);
                            },
                            bloc: bloc.popularMovies,
                            mykey: UniqueKey(),
                            mode: mode,
                          );
                        }
                      });
                    }),
              )
            : Text("Most Popular"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.star), onPressed: () {}),
          IconButton(
            onPressed: () {
              // showSearch(
              //   context: context,
              //   delegate: CustomSearchDelegate(mode: mode),
              // );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(mode: mode)));
            },
            icon: Icon(Icons.search),
          ),
          /*   Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: CircleAvatar(
                child: Icon(Icons.person),
                backgroundColor: Colors.white,
              ),
            ),
          ),  */
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            CreateDrawerHeader(),
            CreateDrawerBody(
                icon: Icons.movie,
                text: 'Movies',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Movies(
                                mode: 'movie',
                              )));
                }),
            CreateDrawerBody(
                icon: Icons.tv,
                text: 'TV Shows',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Movies(mode: 'tv')));
                  // Navigator.push(context, new MaterialPageRoute(builder: (context) => TVShows()));
                }),
            CreateDrawerBody(
                icon: Icons.live_tv,
                text: 'Live TV',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => LiveTV(
                                load: () {
                                  liveTVBloc.fetchLiveTV(M3U_URL);
                                },
                                bloc: liveTVBloc.liveTV,
                              )));
                }),
            Divider(),
            CreateDrawerBody(
              icon: Icons.person,
              text: 'Users',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => TestingClass()));
              },
            ),
            Divider(),
            CreateDrawerBody(
              icon: Icons.collections_bookmark,
              text: 'Steps',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => TestingClass()));
              },
            ),
            CreateDrawerBody(icon: Icons.face, text: 'Authors'),
            CreateDrawerBody(
                icon: Icons.account_box, text: 'Flutter Documentation'),
            CreateDrawerBody(icon: Icons.stars, text: 'Useful Links'),
            Divider(),
            CreateDrawerBody(icon: Icons.bug_report, text: 'Report an issue'),
            ListTile(
              title: Text('0.0.1'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: tab,
    );
  }

  void getgenre() async {
    Repository rp = new Repository();
    gm = await rp.fetchGenre(mode);
    setState(() {
      isLoaded = true;
      _list.addAll(gm.genres);
    });
  }
}
