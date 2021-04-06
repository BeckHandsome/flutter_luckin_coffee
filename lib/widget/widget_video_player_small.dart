import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luckin_coffee/router/navigator_util.dart';
import 'package:flutter_luckin_coffee/router/router_page.dart';
import 'package:video_player/video_player.dart';

class WidgetVideoPlayerSmall extends StatefulWidget {
  WidgetVideoPlayerSmall({Key key, this.url}) : super(key: key);
  final String url;
  @override
  _WidgetVideoPlayerSmallState createState() => _WidgetVideoPlayerSmallState();
}

class _WidgetVideoPlayerSmallState extends State<WidgetVideoPlayerSmall> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(
      widget.url,
    );
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
      showControlsOnInitialize: false,
      showControls: false,
      aspectRatio: 1 / 1,
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
    return _chewieController != null
        ? Stack(
            children: [
              Chewie(
                controller: _chewieController,
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    NavigatorUtil.navigateTo(context, PageRouter.widgetVideoPlayer, params: {'url': widget.url});
                  },
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.arrow_right,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading'),
            ],
          );
  }
}
