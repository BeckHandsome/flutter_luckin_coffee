import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/router/fluro_convert_util.dart';
import 'package:video_player/video_player.dart';

class WidgetVideoPlayer extends StatefulWidget {
  WidgetVideoPlayer({Key key, this.params}) : super(key: key);
  final Map params;
  @override
  _WidgetVideoPlayerState createState() => _WidgetVideoPlayerState();
}

class _WidgetVideoPlayerState extends State<WidgetVideoPlayer> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  Map _params = {};
  void initState() {
    super.initState();
    _params = FluroConvertUtils.fluroMapParamsDecode(widget.params);
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(
      _params['url'],
    );
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
      appBar: AppBar(
        title: Text('视频预览'),
        centerTitle: true,
      ),
      body: _chewieController != null
          ? Chewie(
              controller: _chewieController,
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading'),
                ],
              ),
            ),
    );
  }
}
