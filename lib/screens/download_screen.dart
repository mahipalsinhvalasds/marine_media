import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/my_training/my_training_model.dart';
import 'package:marine_media_enterprises/screens/start_training/start_training_screen.dart';
import 'package:marine_media_enterprises/service/download_manager.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class DownloadScreen extends StatefulWidget {
  final List<Video>? downloadedVideos;
  
  const DownloadScreen({super.key, this.downloadedVideos});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final DownloadManager _downloadManager = DownloadManager();
  List<Video> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    await _downloadManager.initialize();
    if (mounted) {
      setState(() {
        _videos = _downloadManager.downloadedVideos;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigation.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Downloads",
          style: CommonStyle.getRalewayFont(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image.asset(
            LocalImages.backgroundImage2,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.backgroundColor,
                    ),
                  )
                : _videos.isEmpty
                    ? Center(
                        child: Text(
                          "No downloaded videos",
                          style: CommonStyle.getRalewayFont(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 40, bottom: 20),
                        itemCount: _videos.length,
                        itemBuilder: (context, index) {
                          final video = _videos[index];
                          return _buildDownloadedVideoItem(video);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadedVideoItem(Video video) {
    return GestureDetector(
      onTap: () {
        Navigation.push(
          context,
          StartTrainingScreen(video: video),
        );
      },
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (video.image != null && video.image!.isNotEmpty)
                        Image.network(
                          video.image!,
                          width: 120,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.black,
                              child: Icon(
                                Icons.video_library,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        )
                      else
                        Icon(
                          Icons.video_library,
                          color: Colors.white,
                          size: 40,
                        ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      video.title ?? "Untitled Video",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.grey),
        ],
      ),
    );
  }
}
