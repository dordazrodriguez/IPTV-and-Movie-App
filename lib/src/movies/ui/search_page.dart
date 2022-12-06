import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvapp/src/movies/blocs/data_bloc.dart';
import 'package:tvapp/src/movies/blocs/live_tv_bloc.dart';
import 'package:tvapp/src/movies/blocs/search_bloc.dart';
import 'package:tvapp/src/movies/live_tv.dart';
import 'package:tvapp/src/movies/movies.dart';
import 'package:tvapp/src/movies/ui/data_visualizer.dart';

class SearchPage extends StatefulWidget {
  final String mode;

  SearchPage({this.mode});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final mycontroller = TextEditingController();
  int page = 0;
  FocusNode _node;
  String data = "";
  String hint = "Type Something";

  @override
  void initState() {
    _node = FocusNode();
    // _node.addListener(_onFocusChange);
    super.initState();
  }

  // void _onFocusChange() {
  //   if (_node.hasFocus) {
  //     _node.nextFocus();
  //   } else {
  //     _node.requestFocus();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: IconButton(
      //   icon: Icon(Icons.arrow_back_ios),
      //   onPressed: (){
      //     Navigator.pop(context);
      //     Navigator.pop(context);
      //   },
      // ),
      // appBar: AppBar(
      //   // title: Text("Search Page"),
      //   leading: IconButton(
      //       icon: Icon(Icons.arrow_back_ios),
      //       onPressed: () {
      //         Navigator.pushReplacement(
      //             context,
      //             new MaterialPageRoute(
      //                 builder: (context) => Movies(
      //                       mode: widget.mode,
      //                     )));
      //       }),
        // title: TextField(
        //   // focusNode: _node,
        //   controller: mycontroller,
        //   onSubmitted: (text) {
        //     // _node.requestFocus();
        //     if (text != "") {
        //       Navigator.pushReplacement(
        //           context,
        //           new MaterialPageRoute(
        //               builder: (context) => SearchResult(
        //                     mode: widget.mode,
        //                     keyword: text,
        //                   )));
        //     }
        //     setState(() {
        //       hint = "Nothing Typed! Type Again";
        //     });
        //     // mycontroller.clear();
        //   },
        //   autofocus: true,
        // ),
        // actions: <Widget>[
        //   IconButton(
        //       focusNode: _node,
        //       icon: Icon(Icons.search),
        //       onPressed: () {
        //         print("entered");
        //         setState(() {
        //           data = mycontroller.text;
        //         });
        //         mycontroller.clear();
        //       }),
        // ],
      // ),
      // body: FutureBuilder(
      //   future: getKeyword(),
      //   builder: (context, AsyncSnapshot<String> snapshot) {
      //     if (snapshot.hasData && snapshot.data != "") {
      //       print(snapshot.data);
      //       if (snapshot.data.isEmpty) {
      //         return Center(
      //           child: Text("No Data"),
      //         );
      //       } else {
      //         return getData(snapshot.data);
      //       }
      //     } else {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
      // body: data == "" ? Center(child: CircularProgressIndicator()): getData(data),
      body: Center(
        child: TextFormField(
          autofocus: true,
          onFieldSubmitted: (text) {
            if (text != "") {
              if(widget.mode == "live"){
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => LiveTV(
                            load: (){
                              liveTVBloc.searchChannel(text, "https://iptv-org.github.io/iptv/index.country.m3u");
                            },
                            bloc: liveTVBloc.liveTV,
                          )));
              } else {
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => SearchResult(
                            mode: widget.mode,
                            keyword: text,
                          )));
              }
            }
          },
          decoration: new InputDecoration(
            labelText: "Type Here to Search",
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
            //fillColor: Colors.green
          ),
          validator: (val) {
            if (val.length == 0) {
              return "Please type something.";
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.text,
          style: new TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  // Future<String> getKeyword() async{
  //   return data;
  // }

  Widget getData(String keyword) {
    page = 0;
    return DataVisualizer(
      load: () {
        page += 1;
        bloc.searchMovies(page.toString(), keyword, widget.mode);
      },
      bloc: bloc.popularMovies,
      mode: widget.mode,
      mykey: UniqueKey(),
    );
  }
}

class SearchResult extends StatefulWidget {
  final String mode;
  final String keyword;

  SearchResult({this.mode, this.keyword});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  int page = 0;

  @override
  void dispose() {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => Movies(
                  mode: widget.mode,
                )));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keyword),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Movies(
                            mode: widget.mode,
                          )));
            }),
      ),
      body: DataVisualizer(
        load: () {
          page += 1;
          bloc.searchMovies(page.toString(), widget.keyword, widget.mode);
        },
        bloc: bloc.popularMovies,
        mode: widget.mode,
        mykey: UniqueKey(),
      ),
    );
  }
}
