import 'dart:convert';
import 'package:marine_media_enterprises/screens/my_training/my_training_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadManager {
  // Singleton pattern
  static final DownloadManager _instance = DownloadManager._internal();
  
  factory DownloadManager() {
    return _instance;
  }
  
  DownloadManager._internal() {
    _loadDownloads();
  }

  // List to store downloaded videos
  final List<Video> _downloadedVideos = [];
  static const String _storageKey = 'downloaded_videos';
  bool _isLoaded = false;

  // Load downloads from SharedPreferences
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

  // Save downloads to SharedPreferences
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

  // Get all downloaded videos
  Future<List<Video>> getDownloadedVideos() async {
    await _loadDownloads();
    return List.unmodifiable(_downloadedVideos);
  }

  // Get all downloaded videos synchronously (after initial load)
  List<Video> get downloadedVideos => List.unmodifiable(_downloadedVideos);

  // Add a video to downloads
  Future<bool> addDownload(Video video) async {
    await _loadDownloads();
    
    // Check if video is already downloaded
    bool alreadyExists = _downloadedVideos.any((v) => v.id == video.id);
    
    if (!alreadyExists) {
      _downloadedVideos.add(video);
      await _saveDownloads();
      return true; // Successfully added
    }
    
    return false; // Already exists
  }

  // Remove a video from downloads
  Future<void> removeDownload(int videoId) async {
    await _loadDownloads();
    _downloadedVideos.removeWhere((v) => v.id == videoId);
    await _saveDownloads();
  }

  // Check if a video is downloaded
  Future<bool> isDownloadedAsync(int? videoId) async {
    await _loadDownloads();
    if (videoId == null) return false;
    return _downloadedVideos.any((v) => v.id == videoId);
  }

  // Check if a video is downloaded (synchronous, after initial load)
  bool isDownloaded(int? videoId) {
    if (videoId == null) return false;
    return _downloadedVideos.any((v) => v.id == videoId);
  }

  // Clear all downloads
  Future<void> clearAll() async {
    _downloadedVideos.clear();
    await _saveDownloads();
  }

  // Get download count
  int get downloadCount => _downloadedVideos.length;
  
  // Initialize and wait for data to load
  Future<void> initialize() async {
    await _loadDownloads();
  }
}
