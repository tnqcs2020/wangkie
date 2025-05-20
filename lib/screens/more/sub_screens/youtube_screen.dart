// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wangkie_app/models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:wangkie_app/common/app_sizes.dart';

class YoutubeScreen extends StatefulWidget {
  final VideoModel video;
  const YoutubeScreen({super.key, required this.video});

  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  final List<YoutubePlayerController> _controllers =
      [
            'gQDByCdjUXw',
            'iLnmTe5Q2Qw',
            '_WoCV4c6XOE',
            'KmzdUe0RSJo',
            '6jZDSSZZxjQ',
            'p2lYr3vM_1w',
            '7QUtEmBT_-w',
            '34_PXCzGw1M',
          ]
          .map<YoutubePlayerController>(
            (videoId) => YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                hideControls: true,
                hideThumbnail: true,
              ),
            ),
          )
          .toList();
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    _startHideTimer();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  Future<void> _onExitFullScreen() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _showControls = false);
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String days =
        duration.inDays < 10
            ? duration.inDays.toString()
            : twoDigits(duration.inDays);
    String hours =
        duration.inHours < 10
            ? duration.inHours.toString()
            : twoDigits(duration.inHours);
    String minutes =
        duration.inMinutes < 10
            ? duration.inMinutes.toString()
            : twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inDays >= 1) {
      return '$days:$minutes:$seconds';
    } else if (duration.inHours >= 1) {
      return '$hours:$minutes:$seconds';
    } else if (duration.inMinutes >= 1) {
      return '$minutes:$seconds';
    }
    return '0:$seconds';
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          YoutubePlayerBuilder(
            onExitFullScreen: _onExitFullScreen,
            player: YoutubePlayer(
              controller: _controller,
              // topActions: <Widget>[
              //   const SizedBox(width: 8.0),
              //   Expanded(
              //     child: Text(
              //       _controller.metadata.title,
              //       style: const TextStyle(color: Colors.white, fontSize: 18.0),
              //       overflow: TextOverflow.ellipsis,
              //       maxLines: 1,
              //     ),
              //   ),
              //   PlaybackSpeedButton(),
              //   IconButton(
              //     icon: const Icon(Icons.settings, color: Colors.white, size: 20.0),
              //     onPressed: () {
              //       dev.log('Settings Tapped!');
              //     },
              //   ),
              // ],
              onReady: () {
                _isPlayerReady = true;
              },
              // onEnded: (data) {
              // _controller.load(
              //   _ids[(_ids.indexOf(data.videoId) + 1) % _ids.length],
              // );
              // },
              // bottomActions: [
              //   IconButton(
              //     icon: const Icon(Icons.skip_previous, color: Colors.white),
              //     onPressed:
              //         _isPlayerReady
              //             ? () {
              //               int currentIndex = _ids.indexOf(
              //                 _controller.metadata.videoId,
              //               );
              //               int previousIndex =
              //                   (currentIndex - 1 + _ids.length) % _ids.length;
              //               _controller.load(_ids[previousIndex]);
              //             }
              //             : null,
              //   ),
              //   IconButton(
              //     icon: Icon(
              //       _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              //       color: Colors.white,
              //     ),
              //     onPressed:
              //         _isPlayerReady
              //             ? () {
              //               _controller.value.isPlaying
              //                   ? _controller.pause()
              //                   : _controller.play();
              //               setState(() {});
              //             }
              //             : null,
              //   ),
              //   IconButton(
              //     icon: const Icon(Icons.skip_next, color: Colors.white),
              //     onPressed:
              //         _isPlayerReady
              //             ? () {
              //               int currentIndex = _ids.indexOf(
              //                 _controller.metadata.videoId,
              //               );
              //               int nextIndex = (currentIndex + 1) % _ids.length;
              //               _controller.load(_ids[nextIndex]);
              //             }
              //             : null,
              //   ),
              //   const SizedBox(width: 8),
              //   CurrentPosition(),
              //   const SizedBox(width: 8),
              //   ProgressBar(
              //     isExpanded: true,
              //     colors: const ProgressBarColors(
              //       playedColor: Color(0xFFFF0000),
              //       handleColor: Color(0xFFFF0000),
              //       backgroundColor: Colors.grey,
              //     ),
              //   ),
              //   Text(
              //     formatDuration(_videoMetaData.duration),
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   const SizedBox(width: 14),
              //   FullScreenButton(),
              // ],
              // thumbnail: ColoredBox(
              //   color: Colors.black,
              //   child: Image.network(
              //     YoutubePlayer.getThumbnail(
              //       videoId:
              //           _controller.metadata.videoId.isEmpty
              //               ? _controller.initialVideoId
              //               : _controller.metadata.videoId,
              //     ),
              //     fit: BoxFit.contain,
              //     loadingBuilder:
              //         (_, child, progress) =>
              //             progress == null
              //                 ? child
              //                 : Container(color: Colors.black),
              //     errorBuilder:
              //         (context, _, __) => Image.network(
              //           YoutubePlayer.getThumbnail(
              //             videoId:
              //                 _controller.metadata.videoId.isEmpty
              //                     ? _controller.initialVideoId
              //                     : _controller.metadata.videoId,
              //             webp: false,
              //           ),
              //           fit: BoxFit.contain,
              //           loadingBuilder:
              //               (_, child, progress) =>
              //                   progress == null
              //                       ? child
              //                       : Container(color: Colors.black),
              //           errorBuilder: (context, _, __) => Container(),
              //         ),
              //   ),
              // ),
            ),
            builder:
                (BuildContext context, Widget player) => GestureDetector(
                  onTap: _toggleControls,
                  child: Stack(
                    children: [
                      player,
                      if (_showControls)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.3),
                            child: Stack(
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap:
                                            _isPlayerReady
                                                ? () {
                                                  _controller.value.isPlaying
                                                      ? _controller.pause()
                                                      : _controller.play();
                                                  setState(() {});
                                                }
                                                : null,
                                        child: Icon(
                                          _controller.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: AppSizes.iconXl,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            formatDuration(
                                              _controller.value.position,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.white),
                                          ),
                                          Flexible(
                                            child: Slider(
                                              value: _controller
                                                  .value
                                                  .position
                                                  .inSeconds
                                                  .toDouble()
                                                  .clamp(
                                                    0.0,
                                                    _controller
                                                        .value
                                                        .metaData
                                                        .duration
                                                        .inSeconds
                                                        .toDouble(),
                                                  ),
                                              min: 0,
                                              max:
                                                  _controller
                                                      .value
                                                      .metaData
                                                      .duration
                                                      .inSeconds
                                                      .toDouble(),
                                              onChanged: (value) {
                                                _controller.seekTo(
                                                  Duration(
                                                    seconds: value.toInt(),
                                                  ),
                                                );
                                                _startHideTimer();
                                              },
                                              activeColor: Colors.red,
                                              inactiveColor: Colors.white54,
                                            ),
                                          ),
                                          Text(
                                            formatDuration(
                                              _controller
                                                  .value
                                                  .metaData
                                                  .duration,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.white),
                                          ),
                                          SizedBox(width: 10.w),
                                          GestureDetector(
                                            onTap: () {
                                              _controller
                                                  .toggleFullScreenMode();
                                            },
                                            child: const Icon(
                                              Icons.fullscreen,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _space,
                  _text('Title', _videoMetaData.title),
                  _space,
                  _text('Channel', _videoMetaData.author),
                  _space,
                  _text('Video Id', _videoMetaData.videoId),
                  _space,
                  Row(
                    children: [
                      _text(
                        'Playback Quality',
                        _controller.value.playbackQuality ?? '',
                      ),
                      const Spacer(),
                      _text(
                        'Playback Rate',
                        '${_controller.value.playbackRate}x  ',
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed:
                            _isPlayerReady
                                ? () {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                  setState(() {});
                                }
                                : null,
                      ),
                      FullScreenButton(
                        controller: _controller,
                        color: Colors.blueAccent,
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.skip_next),
                      //   onPressed:
                      //       _isPlayerReady
                      //           ? () => _controller.load(
                      //             _ids[(_ids.indexOf(
                      //                       _controller.metadata.videoId,
                      //                     ) +
                      //                     1) %
                      //                 _ids.length],
                      //           )
                      //           : null,
                      // ),
                    ],
                  ),
                  _space,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: _getStateColor(_playerState),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _playerState.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          YoutubePlayer(
                            key: ObjectKey(_controllers[index]),
                            controller: _controllers[index],
                          ),
                          _space,
                          _text('Title', _videoMetaData.title),
                          _space,
                          Row(
                            children: [
                              _text('Channel', _videoMetaData.author),
                              _space,
                              _text('Video Id', _videoMetaData.videoId),
                              _space,
                            ],
                          ),
                        ],
                      );
                    },
                    itemCount: _controllers.length,
                    separatorBuilder:
                        (context, _) => const SizedBox(height: 10.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
    }
  }

  Widget get _space => const SizedBox(height: 10);
}
