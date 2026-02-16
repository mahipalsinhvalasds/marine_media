import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/add_to_training/add_to_training_screen.dart';
import 'package:marine_media_enterprises/screens/home/training_model.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';

class SearchScreen extends StatefulWidget {
  final List<Video> allVideos;

  const SearchScreen({super.key, required this.allVideos});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<VideoList> _filteredVideos = [];
  List<VideoList> _allVideosList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _allVideosList = widget.allVideos
        .expand((video) => video.videoList ?? <VideoList>[])
        .toList();
  }

  void _filterVideos(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVideos = [];
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredVideos = _allVideosList
            .where(
              (video) =>
                  video.title?.toLowerCase().contains(query.toLowerCase()) ??
                  false,
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigation.pop(context);
          },
          child: Icon(Icons.highlight_remove, color: Colors.white, size: 30),
        ),
        title: Text(
          "Search",
          style: CommonStyle.getRalewayFont(
            fontSize: 22,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    LocalImages.logo,
                    color: AppColors.grey,
                    scale: 4,
                  ),
                ),
                SizedBox(height: 10),
                CustomTextfield(
                  textController: _searchController,
                  hintText: "Search here",
                  suffixWidget: Icon(Icons.search),
                  onChanged: _filterVideos,
                ),
                SizedBox(height: 20),
                Expanded(child: searchResults()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchResults() {
    if (_filteredVideos.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(LocalImages.searchBlue, scale: 4),
          SizedBox(height: 10),
          Text(
            "Search for videos",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      );
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 0.90,
      ),
      itemCount: _filteredVideos.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final video = _filteredVideos[index];
        return customVideoCard(video);
      },
    );
  }

  Widget customVideoCard(VideoList video) {
    return GestureDetector(
      onTap: () {
        Navigation.push(context, AddToTrainingScreen(video: video));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  child: video.image != null
                      ? Image.network(
                          video.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              LocalImages.trainingImage,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          LocalImages.trainingImage,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 25,
                  left: 55,
                  child: Icon(Icons.play_circle, color: Colors.grey, size: 40),
                ),
              ],
            ),
            SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                video.title ?? "",
                style: CommonStyle.getRalewayFont(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
