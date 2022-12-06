import 'package:flutter/material.dart';
import 'package:tvapp/globals.dart' as gb;

class CreateDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    "https://freedesignfile.com/upload/2016/10/Dark-with-carbon-fiber-texture-background-vector-06.jpg"))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              right: 16.0,
              child: Text(gb.currentUsersName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }
}

class CreateDrawerBody extends StatelessWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback onTap;

  CreateDrawerBody({this.icon, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
