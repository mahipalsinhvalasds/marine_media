import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/add_to_training/add_to_training_screen.dart';
import 'package:marine_media_enterprises/screens/drawer_screen.dart';
import 'package:marine_media_enterprises/screens/home/home_view_model.dart';
import 'package:marine_media_enterprises/screens/search_screen.dart';
import 'package:marine_media_enterprises/screens/view_all_training_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  HomeViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = Provider.of<HomeViewModel>(context, listen: false);
    mViewModel?.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    mViewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white70,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(Icons.menu, color: Colors.white, size: 30),
        ),
        title: Text(
          "View Training",
          style: CommonStyle.getRalewayFont(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigation.push(context, SearchScreen(allVideos: mViewModel?.video ?? []));
              },
              child: Image.asset(LocalImages.icSearch, height: 28),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            LocalImages.backgroundImage2,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
          ),
          mViewModel?.loading == true ?
              Center(child: CircularProgressIndicator()) :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      LocalImages.logo,
                      color: AppColors.grey,
                      scale: 4,
                    ),
                  ),

                  ListView.builder(
                    itemCount: mViewModel?.video?.length ?? 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, categoryIndex) {
                      final category = mViewModel!.video![categoryIndex];
                      final videosToShow =
                          category.videoList?.take(2).toList() ?? [];
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 24,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    category.category ?? "",
                                    style: CommonStyle.getRalewayFont(
                                      fontSize: category.category == "Bridge Resource Management" ? 16 : 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    Navigation.push(
                                      context,
                                      ViewAllTrainingScreen(data: category),
                                    );
                                  },
                                  child: Text(
                                    "See all",
                                    style: CommonStyle.getRalewayFont(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.lightBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          GridView.builder(
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.95,
                            ),
                            itemCount: videosToShow.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final video = videosToShow[index];
                              return Container(
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
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        video.title ?? "",
                                        style: CommonStyle.getRalewayFont(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigation.push(
                                            context,
                                            AddToTrainingScreen(video: video,),
                                          );
                                        },
                                        child: Container(
                                          width: 120,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "ADD TRAINING",
                                              style: CommonStyle.getRalewayFont(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerScreen(),
    );
  }
}
