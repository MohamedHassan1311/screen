import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../app/core/utils/color_resources.dart';
import '../provider/SpeakProvider.dart';


class VedioPlayer extends StatefulWidget {
  final String filePath ;
  final CarouselController buttonCarouselController ;
  const VedioPlayer({required this.filePath, required this.buttonCarouselController});
  @override
  _VedioPlayerState createState() => _VedioPlayerState();
}

class _VedioPlayerState extends State<VedioPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller=  VideoPlayerController.file(File(widget.filePath));

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);

    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    Provider.of<SpeakProvider>(context, listen: false).getVideoPlayerController(_controller);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Center(
          child: LoadingAnimationWidget.inkDrop(
            size: 50,
            color: ColorResources.PRIMARY_COLOR,
          ),
        ));
  }
}