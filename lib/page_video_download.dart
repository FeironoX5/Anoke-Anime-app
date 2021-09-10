import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PageVideoDownload extends StatefulWidget {
  PageVideoDownload({Key key, this.id}) : super(key: key);
  final id;

  @override
  _PageVideoDownloadState createState() => _PageVideoDownloadState();
}

class _PageVideoDownloadState extends State<PageVideoDownload> {
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
    var dir = await getApplicationDocumentsDirectory();
    _videoPlayerController = VideoPlayerController.file(
        File('${dir.path}/' + widget.id.toString() + '.mp4'));
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
        customControls: CupertinoControls(iconColor: Colors.white, backgroundColor: Colors.black,
          
        ));
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
