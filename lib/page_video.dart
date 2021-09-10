import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class PageVideo extends StatefulWidget {
  PageVideo({Key key, this.id}) : super(key: key);
  final id;

  @override
  _PageVideoState createState() => _PageVideoState();
}

class _PageVideoState extends State<PageVideo> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(
        'https://video.animetop.info/' + widget.id + '.mp4');
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: true,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false,
        allowMuting: false,
        customControls: CupertinoControls(iconColor: Colors.white, backgroundColor: Colors.black)
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hello',
      theme: ThemeData.light().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                    _chewieController
                        .videoPlayerController.value.isInitialized
                    ? Chewie(
                  controller: _chewieController,
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
