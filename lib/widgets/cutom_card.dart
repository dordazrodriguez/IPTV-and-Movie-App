import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCard extends StatefulWidget {
  final String url;
  final String name;
  final String year;
  final Function onTap;
  final Function onFocus;

  CustomCard(
      {this.url, this.name, this.year, @required this.onTap, this.onFocus});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  FocusNode _node;
  AnimationController _controller;
  Animation<double> _animation;
  int _focusAlpha = 100;

  @override
  void initState() {
    _node = FocusNode();
    _node.addListener(_onFocusChange);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _node.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      _controller.forward();
      if (widget.onFocus != null) {
        widget.onFocus();
      }
    } else {
      _controller.reverse();
    }
  }

  void _onTap() {
    _node.requestFocus();
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: _onTap,
      focusNode: _node,
      focusColor: Colors.transparent,
      focusElevation: 0,
      child: buildList(),
    );
  }

  Widget buildList() {
    return ScaleTransition(
      scale: _animation,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: _onTap,
        child: Card(
          elevation: 8.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(widget.url)),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0.0,
                  child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 10.0, left: 8.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: new Container(
                                width: 250.0,
                                child: new Text(
                                    widget.name == null ? "" : widget.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: new Container(
                                width: 250.0,
                                child: new Text(
                                    widget.year == null || widget.year == ""
                                        ? ""
                                        : widget.year.substring(0, 4),
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
