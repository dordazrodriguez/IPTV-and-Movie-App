import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../size_config.dart';
import 'cutom_card.dart';

class CustomGridView extends StatefulWidget {

  final List resultList;
  final void Function(int) onTap;
  final VoidCallback onLoad;
  final Function onFocus;

  CustomGridView({@required this.resultList, @required this.onTap, @required this.onLoad, this.onFocus});

  @override
  _CustomGridViewState createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> with SingleTickerProviderStateMixin {

  String url = 'https://via.placeholder.com/150';
  bool isLoading = false;

  Widget image;

  



  @override
  Widget build(BuildContext context) {
          return buildList();
    
  }

  Widget buildList(){
    return LazyLoadScrollView(
      onEndOfPage: (){
        widget.onLoad();
      },
          child: GridView.builder(
            itemCount: widget.resultList.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: SizeConfig.widthMultiplier.toInt() - 1),
            itemBuilder: (BuildContext context, int index) {
              if(widget.resultList[index].posterPath != null){
                url = 'https://image.tmdb.org/t/p/w500${widget.resultList[index].posterPath}';
              }
              return GestureDetector(
                  child: CustomCard(
                    url: url,
                    name: widget.resultList[index].title,
                    year: widget.resultList[index].releaseDate,
                    onTap: (){widget.onTap(index); },
                    onFocus: (){
                      if(index >= widget.resultList.length-SizeConfig.widthMultiplier.toInt()){
                        widget.onLoad();
                      }
                    },
                  ));
            }),
    );
  }
}