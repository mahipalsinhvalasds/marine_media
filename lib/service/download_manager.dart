import 'dart:convert';
import 'package:marine_media_enterprises/screens/my_training/my_training_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();

  factory DownloadManager() {
    return _instance;
  }

  DownloadManager._internal() {
    _loadDownloads();
  }

  final List<Video> _downloadedVideos = [];
  static const String _storageKey = 'downloaded_videos';
  bool _isLoaded = false;

  Future<void> _loadDownloads() async {
    if (_isLoaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? videosJson = prefs.getString(_storageKey);

      if (videosJson != null) {
        final List<dynamic> videosList = json.decode(videosJson);
        _downloadedVideos.clear();
        _downloadedVideos.addAll(
          videosList.map((json) => Video.fromJson(json)).toList(),
        );
      }
      _isLoaded = true;
    } catch (e) {
      print('Error loading downloads: $e');
    }
  }

  Future<void> _saveDownloads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String videosJson = json.encode(
        _downloadedVideos.map((video) => video.toJson()).toList(),
      );
      await prefs.setString(_storageKey, videosJson);
    } catch (e) {
      print('Error saving downloads: $e');
    }
  }

  Future<List<Video>> getDownloadedVideos() async {
    await _loadDownloads();
    return List.unmodifiable(_downloadedVideos);
  }

  List<Video> get downloadedVideos => List.unmodifiable(_downloadedVideos);

  Future<bool> addDownload(Video video, String filePath) async {
    await _loadDownloads();

    if (_downloadedVideos.any((v) => v.id == video.id)) return false;

    video.localPath = filePath;
    _downloadedVideos.add(video);
    await _saveDownloads();
    return true;
  }


  Future<void> removeDownload(int videoId) async {
    await _loadDownloads();
    _downloadedVideos.removeWhere((v) => v.id == videoId);
    await _saveDownloads();
  }

  Future<bool> isDownloadedAsync(int? videoId) async {
    await _loadDownloads();
    if (videoId == null) return false;
    return _downloadedVideos.any((v) => v.id == videoId);
  }

  bool isDownloaded(int? videoId) {
    if (videoId == null) return false;
    return _downloadedVideos.any((v) => v.id == videoId);
  }

  Future<void> clearAll() async {
    _downloadedVideos.clear();
    await _saveDownloads();
  }

  int get downloadCount => _downloadedVideos.length;

  Future<void> initialize() async {
    await _loadDownloads();
  }
}
