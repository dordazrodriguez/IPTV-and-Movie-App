import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String link;
  final Map<String, String> header;

  CustomVideoPlayer({this.link, this.header});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  IjkMediaController controller = IjkMediaController(autoRotate: true);
  FocusNode _node;

  @override
  void initState() {
    _node = FocusNode();
    super.initState();
    initPlayer();
  }

  initPlayer() async {
    await controller.setNetworkDataSource(widget.link,
        headers: widget.header, autoPlay: true);
    print("set data source success");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildStatusWidget(
    BuildContext context,
    IjkMediaController controller,
    IjkStatus status,
  ) {
    if (status == IjkStatus.noDatasource) {
      return Center(
        child: Text(
          "no data",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (status == IjkStatus.error) {
      return Center(
        child: Text(
          "Error Occured",
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (status == IjkStatus.setDatasourceFail) {
      return Center(
        child: Text(
          "Data Source Failed",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // you can custom your self status widget
    return IjkStatusWidget.buildStatusWidget(context, controller, status);
  }

  void _onKey(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.mediaPlay) {
      controller.play();
    } else if (event.logicalKey == LogicalKeyboardKey.mediaRewind ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      // controller.seekToProgress(controller.index);
      print(controller.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: Scaffold(
        // appBar: AppBar(
        // ),
        body: RawKeyboardListener(
          focusNode: _node,
          onKey: _onKey,
          child: IjkPlayer(
            mediaController: controller,
            statusWidgetBuilder: _buildStatusWidget,
          ),
        ),
      ),
    );
  }
}
