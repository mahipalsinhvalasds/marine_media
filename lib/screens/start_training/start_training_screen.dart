import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:video_player/video_player.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

import '../my_training/my_training_model.dart';

class StartTrainingScreen extends StatefulWidget {
  final Video? video;
  const StartTrainingScreen({super.key,required this.video});

  @override
  State<StartTrainingScreen> createState() => _StartTrainingScreenState();
}

class _StartTrainingScreenState extends State<StartTrainingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _showSubtitles = true;
  String? _errorMessage;
  bool _isLoading = true;
  bool _showControls = true;
  bool _isMuted = false;
  bool _isFullScreen = false;
  VoidCallback? _fullScreenRebuilder;

  bool _showLeftSkip = false;
  bool _showRightSkip = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _initializeVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      _videoController = VideoPlayerController.asset(
        'assets/video/marineMedia.mp4',
      );

      await _videoController!.initialize();

      _videoController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

      setState(() {
        _isVideoInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load video: ${e.toString()}';
        _isLoading = false;
      });
      print('Video initialization error: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _toggleSubtitles() {
    setState(() {
      _showSubtitles = !_showSubtitles;
    });
    _fullScreenRebuilder?.call();
  }

  String get _captionStatusText => _showSubtitles ? 'English' : 'Off';

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _toggleFullScreen() {
    if (_isFullScreen) {
      _exitFullScreen();
    } else {
      _enterFullScreen();
    }
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    setState(() {
      _isFullScreen = true;
    });
    Navigator.of(context)
        .push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: StatefulBuilder(
                  builder: (ctx, setFSState) {
                    _fullScreenRebuilder = () {
                      if (mounted) setFSState(() {});
                    };
                    return _buildPortraitFullScreenPlayer(setFSState);
                  },
                ),
              );
            },
          ),
        )
        .then((_) {
          _fullScreenRebuilder = null;
          _exitFullScreen();
        });
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    setState(() {
      _isFullScreen = false;
    });
  }

  void _skipForward() {
    print('Skip forward triggered');
    if (_videoController != null && _videoController!.value.isInitialized) {
      final currentPosition = _videoController!.value.position;
      final duration = _videoController!.value.duration;
      final newPosition = currentPosition + Duration(seconds: 10);

      if (newPosition <= duration) {
        _videoController!.seekTo(newPosition);
      } else {
        _videoController!.seekTo(duration);
      }

      setState(() {
        _showRightSkip = true;
      });

      Future.delayed(Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _showRightSkip = false;
          });
        }
      });
    }
  }

  void _skipBackward() {
    print('Skip backward triggered');
    if (_videoController != null && _videoController!.value.isInitialized) {
      final currentPosition = _videoController!.value.position;
      final newPosition = currentPosition - Duration(seconds: 10);

      if (newPosition >= Duration.zero) {
        _videoController!.seekTo(newPosition);
      } else {
        _videoController!.seekTo(Duration.zero);
      }

      setState(() {
        _showLeftSkip = true;
      });

      Future.delayed(Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
            _showLeftSkip = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Image.asset(
            LocalImages.backgroundImageBlue,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(Icons.menu, color: Colors.white, size: 30),
                  ),
                  SizedBox(height: 12),
                  Center(child: Image.asset(LocalImages.logo, scale: 4)),
                  SizedBox(height: 14),
                  Text(
                    widget.video?.title ?? "",
                    style: CommonStyle.getRalewayFont(
                      height: 2,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                    child: _buildVideoWidget(),
                  ),
                  SizedBox(height: 80),
                  CustomButton(text: "Download",icon: Icon(Icons.file_download_outlined,color: Colors.white,)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitFullScreenPlayer(
    void Function(void Function()) setFSState,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              ),
            ),
            if (_showSubtitles)
              Positioned(
                left: 16,
                bottom: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.closed_caption, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'English',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _toggleControls,
                      onDoubleTap: _skipBackward,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _toggleControls,
                      onDoubleTap: () {
                        _skipForward();
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
            if (_showControls)
              Positioned.fill(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _togglePlayPause();
                      setFSState(() {});
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _videoController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            if (_showLeftSkip)
              Positioned(
                left: 60,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fast_rewind, color: Colors.white, size: 40),
                        SizedBox(height: 8),
                        Text(
                          '10s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_showRightSkip)
              Positioned(
                right: 60,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fast_forward, color: Colors.white, size: 40),
                        SizedBox(height: 8),
                        Text(
                          '10s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_showControls)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 120, // Fixed height to prevent overflow
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  '${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  _toggleMute();
                                  setFSState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    _isMuted
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),

                              SizedBox(width: 8),

                              // Exit fullscreen button
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.fullscreen_exit,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),

                              SizedBox(width: 8),

                              SizedBox(
                                width: 36,
                                height: 36,
                                child: PopupMenuButton<int>(
                                  padding: EdgeInsets.zero,
                                  color: Colors.black87,
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onSelected: (value) {
                                    if (value == 1) _toggleSubtitles();
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Icon(
                                              Icons.closed_caption,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Captions',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  _captionStatusText,
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white.withOpacity(0.3),
                              thumbColor: Colors.white,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 8,
                              ),
                              trackHeight: 4,
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 16,
                              ),
                            ),
                            child: Slider(
                              value: _videoController!
                                  .value
                                  .position
                                  .inMilliseconds
                                  .toDouble(),
                              min: 0.0,
                              max: _videoController!
                                  .value
                                  .duration
                                  .inMilliseconds
                                  .toDouble(),
                              onChanged: (value) {
                                _videoController!.seekTo(
                                  Duration(milliseconds: value.round()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoWidget() {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text('Loading video...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _initializeVideo, child: Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_isVideoInitialized && _videoController != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Video player
                VideoPlayer(_videoController!),

                // On-video small caption label when subtitles enabled
                if (_showSubtitles)
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.closed_caption,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'English',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                // FIXED: Gesture detection using left/right hit zones
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _toggleControls,
                          onDoubleTap: _skipBackward,
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _toggleControls,
                          onDoubleTap: _skipForward,
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),

                // Skip indicators - always show when active
                if (_showLeftSkip)
                  Positioned(
                    left: 40,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.fast_rewind,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '10s',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                if (_showRightSkip)
                  Positioned(
                    right: 40,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.fast_forward,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '10s',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // FIXED: Video controls overlay - only show when _showControls is true
                if (_showControls)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // FIXED: Play/pause button - only show when controls are visible
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: GestureDetector(
                                onTap: _togglePlayPause,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _videoController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),

                            // Bottom controls
                            Container(
                              constraints: BoxConstraints(maxHeight: 80),
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 36,
                                    child: Row(
                                      children: [
                                        // Time display
                                        Text(
                                          '${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: _toggleMute,
                                              child: Container(
                                                width: 36,
                                                height: 36,
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  _isMuted
                                                      ? Icons.volume_off
                                                      : Icons.volume_up,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap:
                                              _toggleFullScreen, // PORTRAIT FULLSCREEN BUTTON
                                              child: Container(
                                                width: 36,
                                                height: 36,
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.fullscreen,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              width: 36,
                                              height: 36,
                                              child: PopupMenuButton<int>(
                                                padding: EdgeInsets.zero,
                                                color: Colors.white,
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                onSelected: (value) {
                                                  if (value == 1)
                                                    _toggleSubtitles();
                                                },
                                                itemBuilder: (context) => [
                                                  PopupMenuItem<int>(
                                                    value: 1,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                            top: 2,
                                                          ),
                                                          child: Icon(
                                                            Icons.credit_card_outlined,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                            children: [
                                                              Text(
                                                                'Captions',
                                                                style: CommonStyle.getRalewayFont(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                _captionStatusText,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
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

                                  Container(
                                    height: 20,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Colors.white,
                                        inactiveTrackColor: Colors.white
                                            .withOpacity(0.3),
                                        thumbColor: Colors.white,
                                        thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 6,
                                        ),
                                        trackHeight: 3,
                                        overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 12,
                                        ),
                                      ),
                                      child: Slider(
                                        value: _videoController!
                                            .value
                                            .position
                                            .inMilliseconds
                                            .toDouble(),
                                        min: 0.0,
                                        max: _videoController!
                                            .value
                                            .duration
                                            .inMilliseconds
                                            .toDouble(),
                                        onChanged: (value) {
                                          _videoController!.seekTo(
                                            Duration(
                                              milliseconds: value.round(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      child: Center(
        child: Text(
          'Video not available',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
