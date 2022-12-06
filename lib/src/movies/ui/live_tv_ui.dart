import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:m3u/m3u.dart';
import 'package:tvapp/src/movies/blocs/live_tv_bloc.dart';
import 'package:tvapp/src/movies/live_tv.dart';
import 'package:tvapp/src/movies/movies.dart';
import 'package:tvapp/src/movies/ui/search_page.dart';
import 'package:tvapp/widgets/create_Drawer.dart';
import 'package:tvapp/widgets/testing.dart';
import 'package:tvapp/const.dart';
import '../../../size_config.dart';

class LiveTVUI extends StatefulWidget {
  final List<M3uGenericEntry> list;

  LiveTVUI({@required this.list});

  @override
  _LiveTVUIState createState() => _LiveTVUIState();
}

class _LiveTVUIState extends State<LiveTVUI> {
  String _selectedLocation;

  final IjkMediaController _controller = IjkMediaController();

  Set<String> groupList = new Set();

  @override
  void initState() {
    widget.list.forEach((element) {
      // print(element.attributes['group-title']);
      if (element.attributes['group-title'] != null) {
        groupList.add(element.attributes['group-title']);
      }
    });
    print(groupList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: new DropdownButton<String>(
              items: groupList.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Wrap(
                    children: [
                      new Text(
                        val != null ? val : "All Categories",
                        style: TextStyle(
                          color: Colors.white,
                          //fontSize: 3 * SizeConfig.textMultiplier,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              hint: Text(
                _selectedLocation != null
                    ? _selectedLocation
                    : "All Categories",
                style: TextStyle(
                  color: Colors.white,
                  //fontSize: 3 * SizeConfig.textMultiplier,
                ),
              ),
              onChanged: (String val) {
                setState(() {
                  print(val);
                  _selectedLocation = val;
                });
              }),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // showSearch(
              //   context: context,
              //   delegate: CustomSearchDelegate(mode: mode),
              // );
              _controller.dispose();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(mode: "live")));
            },
            icon: Icon(Icons.search),
          ),
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
                  // SystemChrome.setPreferredOrientations([
                  //   DeviceOrientation.portraitUp,
                  //   DeviceOrientation.landscapeRight
                  // ]);
                  _controller.dispose();
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
                  // SystemChrome.setPreferredOrientations([
                  //   DeviceOrientation.portraitUp,
                  //   DeviceOrientation.landscapeRight
                  // ]);
                  _controller.dispose();
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
                                  liveTVBloc.fetchLiveTV(
                                      M3U_URL); //"https://iptv-org.github.io/iptv/index.country.m3u");
                                },
                                bloc: liveTVBloc.liveTV,
                              )));
                }),
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
      body: SizeConfig.isPortrait ? mobileLook() : webLook(),
    );
  }

  Widget mobileLook() {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 5,
          child: Container(
            child: Center(
              child: IjkPlayer(
                mediaController: _controller,
                statusWidgetBuilder: _buildStatusWidget,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: _selectedLocation != null
              ? countryListView(_selectedLocation)
              : customListView(),
          // child: customListView(),
        ),
      ],
    );
  }

  Widget webLook() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: _selectedLocation != null
              ? countryListView(_selectedLocation)
              : customListView(),
          // child: customListView(),
        ),
        Flexible(
          flex: 5,
          child: Container(
            child: Center(
              child: IjkPlayer(
                mediaController: _controller,
                statusWidgetBuilder: _buildStatusWidget,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusWidget(
    BuildContext context,
    IjkMediaController controller,
    IjkStatus status,
  ) {
    if (status == IjkStatus.noDatasource) {
      return Center(
        child: Text(
          "Click on any channel to play.",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (status == IjkStatus.error) {
      return Center(
        child: Text(
          "Sorry to say but there is problem in broadcasting.",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (status == IjkStatus.setDatasourceFail) {
      return Center(
        child: Text(
          "Sorry to say but there is problem in broadcasting.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // you can custom your self status widget
    return IjkStatusWidget.buildStatusWidget(context, controller, status);
  }

  Widget countryListView(String country) {
    List<M3uGenericEntry> _singleList = new List();
    widget.list.forEach((element) {
      print(element.attributes['group-title']);
      print(country);
      if (element.attributes['group-title'] == country) {
        _singleList.add(element);
      }
    });
    print(_singleList);

    return ListView.builder(
      itemCount: _singleList.length,
      itemBuilder: (context, index) {
        M3uGenericEntry project = _singleList[index];

        return GestureDetector(
          onTap: () {
            // CallCustomMethods.myDialog(
            //     project.link, context);
            // _playOnMX(project.link);
            // Navigator.push(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => VideoApp(
            //               link: project.link,
            //             )));
          },
          child: ListTile(
            onTap: () {
              _controller.stop();
              _controller.setNetworkDataSource(project.link);
            },
            leading: CachedNetworkImage(
              width: 50.0,
              imageUrl: project.attributes['tvg-logo'],
              placeholder: (context, url) {
                return Image.network(
                    'https://banner2.cleanpng.com/20180524/hax/kisspng-television-download-creative-pull-the-spot-free-5b068cd0ec24e6.9980797815271559209673.jpg',
                    width: 50.0);
              },
              // progressIndicatorBuilder:
              //     (context, url, downloadProgress) =>
              //         CircularProgressIndicator(
              //             value: downloadProgress.progress),
              errorWidget: (context, url, error) => Image.network(
                  'https://banner2.cleanpng.com/20180524/hax/kisspng-television-download-creative-pull-the-spot-free-5b068cd0ec24e6.9980797815271559209673.jpg',
                  width: 50.0),
            ),
            title: Text(project.title),
          ),
        );
      },
    );
  }

  Widget customListView() {
    return GroupedListView<M3uGenericEntry, String>(
      sort: false,
      floatingHeader: true,
      elements: widget.list,
      groupBy: (M3uGenericEntry element) {
        return element.attributes['group-title'];
      },
      itemBuilder: (context, element) {
        M3uGenericEntry project = element;
        // print(project.attributes);
        return GestureDetector(
          onTap: () {
            // CallCustomMethods.myDialog(
            //     project.link, context);
            // _playOnMX(project.link);
            // Navigator.push(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => VideoApp(
            //               link: project.link,
            //             )));
          },
          child: ListTile(
            onTap: () {
              _controller.stop();
              _controller.setNetworkDataSource(project.link);
            },
            leading: CachedNetworkImage(
              width: 50.0,
              imageUrl: project.attributes['tvg-logo'],
              placeholder: (context, url) {
                return Image.network(
                    'https://banner2.cleanpng.com/20180524/hax/kisspng-television-download-creative-pull-the-spot-free-5b068cd0ec24e6.9980797815271559209673.jpg',
                    width: 50.0);
              },
              // progressIndicatorBuilder:
              //     (context, url, downloadProgress) =>
              //         CircularProgressIndicator(
              //             value: downloadProgress.progress),
              errorWidget: (context, url, error) => Image.network(
                  'https://banner2.cleanpng.com/20180524/hax/kisspng-television-download-creative-pull-the-spot-free-5b068cd0ec24e6.9980797815271559209673.jpg',
                  width: 50.0),
            ),
            title: Text(project.title),
          ),
        );
      },
      groupSeparatorBuilder: (value) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )));
      },
    );
  }
}
