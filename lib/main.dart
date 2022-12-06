import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvapp/AWS_User_AuthLogin/screens/home_screen.dart';
import 'package:tvapp/size_config.dart';
import 'package:tvapp/src/movies/movies.dart';
//import 'package:window_size/window_size.dart';

void main() {
  runApp(new LayoutBuilder(builder: (context, constraints) {
    return OrientationBuilder(builder: (context, orientation) {
      SizeConfig().init(constraints, orientation);
      return Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.deepOrange,
              primaryColorDark: Colors.deepOrange,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepOrangeAccent,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.deepOrange,
              primaryColorDark: Colors.deepOrange,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepOrangeAccent,
            ),
            themeMode: ThemeMode.dark,
            home: Movies(mode: 'movie'),
          ));
    });
  }));
  //setWindowTitle("");
}
