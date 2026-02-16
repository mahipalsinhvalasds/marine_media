import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/download_screen.dart';
import 'package:marine_media_enterprises/screens/drawer_screen.dart';
import 'package:marine_media_enterprises/service/download_manager.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/common_methods/common_methods.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../my_training/my_training_model.dart';
import '../start_quiz_screen.dart';

class StartTrainingScreen extends StatefulWidget {
  final Video? video;
  const StartTrainingScreen({super.key, required this.video});

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

  String? _subtitleUrl;
  String? _subtitleLanguage;
  Timer? _subtitleTimer;
  String _currentSubtitle = '';
  List<SubtitleCue> _subtitleCues = [];

  final DownloadManager _downloadManager = DownloadManager();
  bool _isDownloading = false;
  bool _isDownloaded = false;
  double _downloadProgress = 0.0;
  bool _hasNavigatedToQuiz = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeDownloadManager();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _initializeDownloadManager() async {
    await _downloadManager.initialize();
    if (mounted) {
      setState(() {
      });
    }
  }

  void _initializeVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final localPath = widget.video?.localPath;
      final videoUrl = widget.video?.video;

      if (localPath != null && File(localPath).existsSync()) {
        _videoController = VideoPlayerController.file(File(localPath));
      } else if (videoUrl != null && videoUrl.isNotEmpty) {
        _videoController =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      } else {
        throw Exception('Video source not found');
      }

      await _videoController!.initialize();

      _videoController!.addListener(() {
        if (!mounted) return;

        setState(() {});
        _fullScreenRebuilder?.call();

        if (!_hasNavigatedToQuiz &&
            _videoController!.value.isInitialized &&
            _videoController!.value.position >=
                _videoController!.value.duration &&
            _videoController!.value.duration.inMilliseconds > 0) {
          _onVideoCompleted();
        }
      });

      _initializeSubtitles();
      _loadSubtitleContent();

      setState(() {
        _isVideoInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load video';
        _isLoading = false;
      });
    }
  }


  void _initializeSubtitles() {
    if (widget.video?.localSubtitlePath != null &&
        widget.video!.localSubtitlePath!.isNotEmpty) {
      _subtitleUrl = widget.video!.localSubtitlePath;
      _subtitleLanguage = widget.video!.videoSubtitle?.first.audioType;
    } else if (widget.video?.videoSubtitle != null &&
        widget.video!.videoSubtitle!.isNotEmpty) {
      _subtitleUrl = widget.video!.videoSubtitle!.first.filePath;
      _subtitleLanguage = widget.video!.videoSubtitle!.first.audioType;
    }
  }


  void _loadSubtitleContent() async {
    if (_subtitleUrl == null || !_showSubtitles) return;

    try {
      if (_subtitleUrl!.endsWith('.vtt') &&
          File(_subtitleUrl!).existsSync()) {
        final content = await File(_subtitleUrl!).readAsString();
        _subtitleCues = _parseVTT(content);
        _startSubtitleSync();
        return;
      }

      final response = await http.get(Uri.parse(_subtitleUrl!));
      if (response.statusCode == 200) {
        _subtitleCues = _parseVTT(response.body);
        _startSubtitleSync();
      }
    } catch (e) {
      debugPrint('Subtitle load failed: $e');
    }
  }



  List<SubtitleCue> _parseVTT(String vttContent) {
    List<SubtitleCue> cues = [];
    final lines = vttContent.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.contains('-->')) {
        final parts = line.split('-->');
        if (parts.length == 2) {
          final startTime = _parseVTTTimestamp(parts[0].trim());
          final endTime = _parseVTTTimestamp(parts[1].trim());

          String text = '';
          for (int j = i + 1; j < lines.length; j++) {
            final textLine = lines[j].trim();
            if (textLine.isEmpty) break;
            if (text.isNotEmpty) text += ' ';
            text += textLine;
          }

          if (text.isNotEmpty) {
            cues.add(
              SubtitleCue(startTime: startTime, endTime: endTime, text: text),
            );
          }
        }
      }
    }

    return cues;
  }

  Duration _parseVTTTimestamp(String timestamp) {
    final parts = timestamp.split(':');
    int hours = 0;
    int minutes = 0;
    double seconds = 0;

    if (parts.length == 3) {
      hours = int.tryParse(parts[0]) ?? 0;
      minutes = int.tryParse(parts[1]) ?? 0;
      seconds = double.tryParse(parts[2]) ?? 0;
    } else if (parts.length == 2) {
      minutes = int.tryParse(parts[0]) ?? 0;
      seconds = double.tryParse(parts[1]) ?? 0;
    }

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds.floor(),
      milliseconds: ((seconds - seconds.floor()) * 1000).round(),
    );
  }

  void _startSubtitleSync() {
    _subtitleTimer?.cancel();
    _subtitleTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_videoController != null &&
          _videoController!.value.isInitialized &&
          _showSubtitles) {
        final currentPosition = _videoController!.value.position;
        _updateCurrentSubtitle(currentPosition);
      }
    });
  }

  void _updateCurrentSubtitle(Duration currentPosition) {
    String newSubtitle = '';

    for (final cue in _subtitleCues) {
      if (currentPosition >= cue.startTime && currentPosition <= cue.endTime) {
        newSubtitle = cue.text;
        break;
      }
    }

    if (newSubtitle != _currentSubtitle) {
      setState(() {
        _currentSubtitle = newSubtitle;
      });
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
        _showControls = true;
      } else {
        _videoController!.play();
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted && _videoController!.value.isPlaying) {
            setState(() {
              _showControls = false;
            });
          }
        });
      }
    });
    _fullScreenRebuilder?.call();
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
    if (_showSubtitles) {
      _loadSubtitleContent();
    }
    _fullScreenRebuilder?.call();
  }

  String get _captionStatusText =>
      _showSubtitles ? (_subtitleLanguage ?? 'English') : 'Off';

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    _fullScreenRebuilder?.call();
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

  // void _skipForward() async {
  //   print('Skip forward triggered');
  //   if (_videoController != null && _videoController!.value.isInitialized) {
  //     final currentPosition = _videoController!.value.position;
  //     final duration = _videoController!.value.duration;
  //     final newPosition = currentPosition + Duration(seconds: 10);
  //
  //     setState(() {
  //       _showRightSkip = true;
  //     });
  //     _fullScreenRebuilder?.call();
  //
  //     try {
  //       if (newPosition <= duration) {
  //         await _videoController!.seekTo(newPosition);
  //         print('Skipped forward to: ${newPosition.inSeconds}s');
  //       } else {
  //         await _videoController!.seekTo(duration);
  //         print('Skipped to end: ${duration.inSeconds}s');
  //       }
  //     } catch (e) {
  //       print('Error skipping forward: $e');
  //     }
  //
  //     Future.delayed(Duration(milliseconds: 1200), () {
  //       if (mounted) {
  //         setState(() {
  //           _showRightSkip = false;
  //         });
  //         _fullScreenRebuilder?.call();
  //       }
  //     });
  //   } else {
  //     print('Video controller not ready for skip forward');
  //   }
  // }
  //
  // void _skipBackward() async {
  //   print('Skip backward triggered');
  //   if (_videoController != null && _videoController!.value.isInitialized) {
  //     final currentPosition = _videoController!.value.position;
  //     final newPosition = currentPosition - Duration(seconds: 10);
  //
  //     setState(() {
  //       _showLeftSkip = true;
  //     });
  //     _fullScreenRebuilder?.call();
  //
  //     try {
  //       if (newPosition >= Duration.zero) {
  //         await _videoController!.seekTo(newPosition);
  //         print('Skipped backward to: ${newPosition.inSeconds}s');
  //       } else {
  //         await _videoController!.seekTo(Duration.zero);
  //         print('Skipped to start: 0s');
  //       }
  //     } catch (e) {
  //       print('Error skipping backward: $e');
  //     }
  //
  //     Future.delayed(Duration(milliseconds: 1200), () {
  //       if (mounted) {
  //         setState(() {
  //           _showLeftSkip = false;
  //         });
  //         _fullScreenRebuilder?.call();
  //       }
  //     });
  //   } else {
  //     print('Video controller not ready for skip backward');
  //   }
  // }

  void _showDownloadLimitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 260,
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding:
            EdgeInsets.symmetric(horizontal: 20) +
                EdgeInsets.only(top: 20, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important message',
                  style: CommonStyle.getRalewayFont(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'The limit of 3 video downloads has been reached. Please delete a previously downloaded video.',
                  style: CommonStyle.getRalewayFont(
                    fontSize: 20,
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigation.pop(context);
                    },
                    child: Text(
                      'CANCEL',
                      style: CommonStyle.getRalewayFont(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _downloadVideo() async {
    if (widget.video == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No video to download'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_downloadManager.isDownloaded(widget.video!.id)) {
      _deleteDownloadedVideo(widget.video!);
      return;
    }

    if (_downloadManager.downloadCount >= 3) {
      _showDownloadLimitDialog();
      return;
    }

    bool hasPermission = await checkStoragePermission();

    if (!hasPermission) {
      permissionDialog();
      return;
    }

    _startDownload();
  }


  Future<void> _startDownload() async {
    try {
      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      final dir = await getApplicationDocumentsDirectory();

      final videoPath = '${dir.path}/${widget.video!.id}.mp4';

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(minutes: 10),
          responseType: ResponseType.stream,
        ),
      );

      final videoResponse = await dio.get<ResponseBody>(
        widget.video!.video!,
        options: Options(responseType: ResponseType.stream),
      );

      final videoFile = File(videoPath);
      final videoSink = videoFile.openWrite();

      final total = int.tryParse(
        videoResponse.headers.value('content-length') ?? '0',
      ) ??
          0;

      int received = 0;

      await videoResponse.data!.stream.listen(
            (chunk) {
          received += chunk.length;
          videoSink.add(chunk);

          if (total > 0) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
        cancelOnError: true,
      ).asFuture();

      await videoSink.close();
      String? subtitlePath;

      if (widget.video!.videoSubtitle != null &&
          widget.video!.videoSubtitle!.isNotEmpty) {
        final subtitleUrl = widget.video!.videoSubtitle!.first.filePath;

        subtitlePath = '${dir.path}/${widget.video!.id}.vtt';

        final subtitleResponse = await dio.get<String>(
          subtitleUrl!,
          options: Options(responseType: ResponseType.plain),
        );

        await File(subtitlePath).writeAsString(subtitleResponse.data ?? '');
      }

      widget.video!
        ..localPath = videoPath
        ..localSubtitlePath = subtitlePath;

      await _downloadManager.addDownload(widget.video!, videoPath);

      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });

      CommonMethods.showCustomSnackBar(
        context: context,
        text: "Video downloaded successfully",
      );
    } catch (e) {
      setState(() => _isDownloading = false);
      debugPrint('Download error: $e');
    }
  }



  void _deleteDownloadedVideo(Video video) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 220,
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding:
                EdgeInsets.symmetric(horizontal: 20) +
                EdgeInsets.only(top: 20, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important message',
                  style: CommonStyle.getRalewayFont(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Are you sure you want to delete this video from your downloads?',
                  style: CommonStyle.getRalewayFont(
                    fontSize: 18,
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigation.pop(context);
                      },
                      child: Text(
                        'CANCEL',
                        style: CommonStyle.getRalewayFont(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    TextButton(
                      onPressed: () {
                        _downloadManager.removeDownload(video.id!);
                        setState(() {
                          _isDownloaded = false;
                        });
                        Navigation.pop(context);
                        CommonMethods.showCustomSnackBar(
                          context: context,
                          text: "Video deleted successfully",
                        );
                      },
                      child: Text(
                        'DELETE',
                        style: CommonStyle.getRalewayFont(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToDownloads() {
    Navigation.push(
      context,
      DownloadScreen(downloadedVideos: _downloadManager.downloadedVideos),
    );
  }

  void _downloaded() {
    setState(() {
      _isDownloaded = !_isDownloaded;
    });
  }

  void _onVideoCompleted() async {
    if (widget.video != null && !_hasNavigatedToQuiz) {
      _hasNavigatedToQuiz = true;
      await Navigation.push(
        context,
        StartQuizScreen(
          videoTitle: widget.video!.title ?? '',
          videoId: widget.video!.videoId ?? 0,
        ),
      );
      if (mounted) {
        setState(() {
          _hasNavigatedToQuiz = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _subtitleTimer?.cancel();
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
      drawer: DrawerScreen(),
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
                  if (_isDownloading)
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _downloadProgress,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 8,
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          text:
                              'Downloading - ${(_downloadProgress * 100).toInt()}%',
                          // icon: Image.asset(
                          //   _downloadManager.isDownloaded(widget.video?.id)
                          //       ? LocalImages.downloaded
                          //       :  LocalImages.download,
                          //   color: Colors.white,
                          // ),
                        ),
                      ],
                    )
                  else
                    CustomButton(
                      text: _downloadManager.isDownloaded(widget.video?.id)
                          ? "Downloaded"
                          : "Download",
                      icon: Image.asset(
                        _downloadManager.isDownloaded(widget.video?.id)
                            ? LocalImages.downloaded
                            : LocalImages.download,
                        color: Colors.white,
                      ),
                      onTap: _downloadManager.isDownloaded(widget.video?.id)
                          ? _downloaded
                          : _downloadVideo,
                    ),
                  SizedBox(height: 10),
                  if (_isDownloaded)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _deleteDownloadedVideo(widget.video!);
                            },
                            child: Text(
                              "Delete Download",
                              style: CommonStyle.getRalewayFont(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Divider(color: AppColors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              _navigateToDownloads();
                            },
                            child: Text(
                              "View My Download",
                              style: CommonStyle.getRalewayFont(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 50),
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
            if (_showSubtitles && _currentSubtitle.isNotEmpty)
              Positioned(
                left: 20,
                right: 20,
                bottom: _showControls ? 140 : 30,
                child: IgnorePointer(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _currentSubtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _toggleControls();
                        setFSState(() {});
                      },
                      // onDoubleTap: _skipBackward,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _toggleControls();
                        setFSState(() {});
                      },
                      // onDoubleTap: _skipForward,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
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
                child: IgnorePointer(
                  child: Container(
                    height: 180,
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
                  ),
                ),
              ),
            if (_showControls)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 100,
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
                        color: Colors.white.withOpacity(0.95),
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

            // Bottom controls - separate layer
            if (_showControls)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 100),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            // Time display
                            Text(
                              '${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _toggleMute();
                                    setFSState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      _isMuted ? Icons.volume_off : Icons.volume_up,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
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
                                PopupMenuButton<int>(
                                  padding: EdgeInsets.zero,
                                  color: Colors.black87,
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                onSelected: (value) {
                                  if (value == 1) {
                                    _toggleSubtitles();
                                    setFSState(() {});
                                  }
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
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 24,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white.withOpacity(0.3),
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
                                  .toDouble()
                                  .clamp(
                                    0.0,
                                    _videoController!
                                        .value
                                        .duration
                                        .inMilliseconds
                                        .toDouble(),
                                  ),
                              min: 0.0,
                              max: _videoController!.value.duration.inMilliseconds
                                  .toDouble(),
                              onChanged: (v) {},
                            ),
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
                VideoPlayer(_videoController!),
                if (_showSubtitles && _currentSubtitle.isNotEmpty)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: _showControls ? 100 : 20,
                    child: IgnorePointer(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _currentSubtitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
                          // onDoubleTap: _skipBackward,
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _toggleControls,
                          // onDoubleTap: _skipForward,
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
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
                if (_showControls)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        height: 180,
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
                      ),
                    ),
                  ),
                // Play/pause button - separate layer to capture taps
                if (_showControls)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: Center(
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
                  ),
                if (_showControls)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
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
                                IgnorePointer(
                                  child: Text(
                                    '${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                                      onTap: _toggleFullScreen,
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
                                                  padding: EdgeInsets.only(
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
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Captions',
                                                        style:
                                                            CommonStyle.getRalewayFont(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        _captionStatusText,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 30),
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
                                inactiveTrackColor: Colors.white.withOpacity(
                                  0.3,
                                ),
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
                                    .toDouble()
                                    .clamp(
                                      0.0,
                                      _videoController!
                                          .value
                                          .duration
                                          .inMilliseconds
                                          .toDouble(),
                                    ),
                                min: 0.0,
                                max: _videoController!
                                    .value
                                    .duration
                                    .inMilliseconds
                                    .toDouble(),
                                onChanged: (v) {},
                              ),
                            ),
                          ),
                        ],
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

  bool _isPermissionDialogOpen = false;

  void permissionDialog() {
    if (_isPermissionDialogOpen) return;

    _isPermissionDialogOpen = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 230,
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding:
                EdgeInsets.symmetric(horizontal: 20) +
                EdgeInsets.only(top: 20, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important message',
                  style: CommonStyle.getRalewayFont(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'In order to download the file on your device, Marine Media required storage permission',
                  style: CommonStyle.getRalewayFont(
                    fontSize: 18,
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _isPermissionDialogOpen = false;
                        Navigation.pop(context);
                      },
                      child: Text(
                        'DENY',
                        style: CommonStyle.getRalewayFont(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    TextButton(
                      onPressed: () async {
                        _isPermissionDialogOpen = false;
                        Navigation.pop(context);
                        await requestStoragePermission();
                      },
                      child: Text(
                        'AGREE',
                        style: CommonStyle.getRalewayFont(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> isAndroid13OrAbove() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  Future<void> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        if (await isAndroid13OrAbove()) {
          final statuses = await [
            Permission.photos,
            Permission.videos,
          ].request();

          if (statuses[Permission.photos]?.isGranted == true ||
              statuses[Permission.videos]?.isGranted == true) {
            _onPermissionGranted();
          } else if (statuses.values.any((e) => e.isPermanentlyDenied)) {
            showSettingsDialog();
          } else {
            _onPermissionDenied();
          }
        } else {
          final status = await Permission.storage.request();
          _handlePermissionStatus(status);
        }
      }
    } catch (_) {
      CommonMethods.showCustomSnackBar(
        context: context,
        text: "Permission error",
      );
    }
  }

  void _handlePermissionStatus(PermissionStatus status) {
    if (status.isGranted) {
      _onPermissionGranted();
    } else if (status.isPermanentlyDenied) {
      showSettingsDialog();
    } else {
      _onPermissionDenied();
    }
  }

  void _onPermissionGranted() {
    if (mounted) {
      CommonMethods.showCustomSnackBar(
        context: context,
        text: "Permission granted successfully",
      );
      _startDownload();
    }
  }

  void _onPermissionDenied() {
    if (mounted) {
      CommonMethods.showCustomSnackBar(
        context: context,
        text: "Permission is required to download files",
      );
    }
  }


  void showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text(
            'Storage permission is required to download files. Please enable it in app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
                _checkPermissionAfterSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _checkPermissionAfterSettings() async {
    await Future.delayed(Duration(milliseconds: 500));

    bool hasPermission = await checkStoragePermission();

    if (hasPermission) {
      CommonMethods.showCustomSnackBar(
        context: context,
        text: "Permission granted! Starting download...",
      );
      _startDownload();
    } else {
      CommonMethods.showCustomSnackBar(
        context: context,
        text: "Permission still not granted",
      );
    }
  }

  Future<bool> checkStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        if (await isAndroid13OrAbove()) {
          final photosStatus = await Permission.photos.status;
          final videosStatus = await Permission.videos.status;
          return photosStatus.isGranted || videosStatus.isGranted;
        } else {
          final status = await Permission.storage.status;
          return status.isGranted;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.status;
        return status.isGranted;
      }
      return false;
    } catch (e) {
      print('Error checking storage permission: $e');
      return false;
    }
  }
}

class SubtitleCue {
  final Duration startTime;
  final Duration endTime;
  final String text;

  SubtitleCue({
    required this.startTime,
    required this.endTime,
    required this.text,
  });
}
