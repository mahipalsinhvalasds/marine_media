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

  final List<Map> interpersonalSkills = [
    {
      "heading": "Interpersonal Skills",
      "title": "INTERVIEW TECHNIQUES",
      "subTitle": "Part 2\nTHE INTERVIEW",
      "name": "Interview Techniques - PART 2",
      "image": LocalImages.trainingImage,
    },
    {
      "title": "INTERVIEW TECHNIQUES",
      "subTitle": "Part 1\nBASIC PRINCIPLES",
      "name": "Interview Techniques - PART 1",
      "image": LocalImages.trainingImage,
    },
  ];

  final List<Map> bridgeManagements = [
    {
      "name": "Master / Pilot Relationship",
      "image": LocalImages.trainingImage2,
    },
  ];

  final List<Map> crewWelfares = [
    {
      "title": "JUST CULTURE",
      "name": "Just Culture",
      "isBox": false,
      "isBlur": false,
      "image": LocalImages.trainingImage,
    },
    {
      "title": "Drug & Alcohol Abuse at Sea",
      "name": "Drug & Alcohol Abuse",
      "isBox": true,
      "isBlur": true,
      "image": LocalImages.trainingImage,
    },
  ];

  final List<Map> mentalHealths = [
    {"name": "Social Isolation", "image": LocalImages.trainingImage},
    {
      "name": "Mental Health and Crew Health",
      "image": LocalImages.trainingImage,
    },
  ];

  final List<Map> cyberSecurity = [
    {
      "title": "Prevention and Handling of",
      "subTitle": "Cyber Attacks\nonboard Ship",
      "name": "Prevention and Handling of Cyber Attacks onboard Ship",
      "image": LocalImages.trainingImage,
    },
    {"name": "Safe Use of Mobile Device", "image": LocalImages.trainingImage},
  ];

  final List<Map> shipBoardOperations = [
    {
      "title": "SHIPBOARD OPERATIONS-MANAGEMENT ONBOARD",
      "subTitle": "PROGRAMME 1",
      "subMenuTitle": "CRISIS",
      "name": "Management Onboard - programme 1-crisis",
      "image": LocalImages.trainingImage2,
    },
    {
      "title": "",
      "subTitle": "",
      "subMenuTitle": "",
      "name": "Entry to Enclosed Spaces",
      "image": LocalImages.trainingImage2,
    },
  ];

  final List<Map> inspections = [
    {
      "title": "ANSWER THE\nQUESTION",
      "subTitle": "SHIP INSPECTION FOR MARINERS",
      "name": "Answer the Question - Ship Inspection for Mariners",
      "image": LocalImages.trainingImage2,
    },
  ];

  final List<Map> gDPRs = [
    {"name": "GDPR", "image": LocalImages.trainingImage2},
  ];

  final List<Map> companySpecificTrainings = [
    {"name": "Company Specific 1", "image": LocalImages.trainingImage2},
  ];

  final List<Map> maritimeSecuritys = [
    {
      "title": "MARITIME SECURITY",
      "subTitle": "Staying Safe from Security Threats",
      "name": "MARITIME SECURITY - Staying Safe from Security Threats",
      "image": LocalImages.trainingImage2,
    },
  ];

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
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigation.push(context, SearchScreen());
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    category.category ?? "",
                                    style: CommonStyle.getRalewayFont(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
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
                                                fontSize: 13,
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
                  //       SizedBox(height: 28),
                  //       customRow("Bridge Resource Management", bridgeManagements,fontSize: 14),
                  //       SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: bridgeManagements.length > 2
                  //             ? 2
                  //             : bridgeManagements.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final bridgeManagement = bridgeManagements[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(4),
                  //                     topRight: Radius.circular(4),
                  //                   ),
                  //                   child: Image.asset(
                  //                     bridgeManagement["image"] ??
                  //                         LocalImages.trainingImage2,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     bridgeManagement["name"],
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 GestureDetector(
                  //                   onTap: (){
                  //                     Navigation.push(context, AddToTrainingScreen());
                  //                   },
                  //                   child: Container(
                  //                     width: 120,
                  //                     height: 32,
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.blueAccent,
                  //                       borderRadius: BorderRadius.circular(6),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         "ADD TRAINING",
                  //                         style: CommonStyle.getRalewayFont(
                  //                           fontSize: 11,
                  //                             fontWeight: FontWeight.w700
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     SizedBox(height: 28),
                  //       customRow("Crew Welfare", crewWelfares),
                  // SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: crewWelfares.length > 2
                  //             ? 2
                  //             : crewWelfares.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final crewWelfare = crewWelfares[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Stack(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(4),
                  //                         topRight: Radius.circular(4),
                  //                       ),
                  //                       child: crewWelfare["isBlur"]
                  //                           ? ImageFiltered(
                  //                               imageFilter: ImageFilter.blur(
                  //                                 sigmaX: 10,
                  //                                 sigmaY: 10,
                  //                               ),
                  //                               child: Image.asset(
                  //                                 crewWelfare["image"] ??
                  //                                     LocalImages.trainingImage,
                  //                               ),
                  //                             )
                  //                           : ImageFiltered(
                  //                               imageFilter: ImageFilter.blur(
                  //                                 sigmaX: 2,
                  //                                 sigmaY: 2,
                  //                               ),
                  //                               child: Image.asset(
                  //                                 crewWelfare["image"] ??
                  //                                     LocalImages.trainingImage,
                  //                               ),
                  //                             ),
                  //                     ),
                  //                     Column(
                  //                       children: [
                  //                         SizedBox(height: 30),
                  //                         crewWelfare["isBox"]
                  //                             ? Center(
                  //                                 child: Container(
                  //                                   height: 30,
                  //                                   width: 100,
                  //                                   padding: EdgeInsets.symmetric(
                  //                                     horizontal: 8,
                  //                                     vertical: 4,
                  //                                   ),
                  //                                   decoration: BoxDecoration(
                  //                                     border: Border.all(
                  //                                       color: Colors.white,
                  //                                     ),
                  //                                     color: Colors.black.withOpacity(
                  //                                       0.8,
                  //                                     ),
                  //                                   ),
                  //                                   child: Text(
                  //                                     crewWelfare["title"],
                  //                                     style:
                  //                                         CommonStyle.getRalewayFont(
                  //                                           fontSize: 6,
                  //                                           fontWeight:
                  //                                               FontWeight.w800,
                  //                                         ),
                  //                                     textAlign: TextAlign.center,
                  //                                   ),
                  //                                 ),
                  //                               )
                  //                             : Center(
                  //                                 child: Text(
                  //                                   crewWelfare["title"],
                  //                                   style: CommonStyle.getRalewayFont(
                  //                                     fontSize: 10,
                  //                                     fontWeight: FontWeight.w800,
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     crewWelfare["name"],
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 Center(
                  //                   child: GestureDetector(
                  //                     onTap: (){
                  //                       Navigation.push(context, AddToTrainingScreen());
                  //                     },
                  //                     child: Container(
                  //                       width: 120,
                  //                       height: 32,
                  //                       decoration: BoxDecoration(
                  //                         color: Colors.blueAccent,
                  //                         borderRadius: BorderRadius.circular(6),
                  //                       ),
                  //                       child: Center(
                  //                         child: Text(
                  //                           "ADD TRAINING",
                  //                           style: CommonStyle.getRalewayFont(
                  //                             fontSize: 11,
                  //                               fontWeight: FontWeight.w700
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 28),
                  //       customRow("Mental Health", mentalHealths),
                  //       SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: mentalHealths.length > 2
                  //             ? 2
                  //             : mentalHealths.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final mentalHealth = mentalHealths[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Stack(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(4),
                  //                         topRight: Radius.circular(4),
                  //                       ),
                  //                       child: Image.asset(
                  //                         mentalHealth["image"] ??
                  //                             LocalImages.trainingImage,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     mentalHealth["name"],
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 Center(
                  //                   child: GestureDetector(
                  //                     onTap: (){
                  //                       Navigation.push(context, AddToTrainingScreen());
                  //                     },
                  //                     child: Container(
                  //                       width: 120,
                  //                       height: 32,
                  //                       decoration: BoxDecoration(
                  //                         color: Colors.blueAccent,
                  //                         borderRadius: BorderRadius.circular(6),
                  //                       ),
                  //                       child: Center(
                  //                         child: Text(
                  //                           "ADD TRAINING",
                  //                           style: CommonStyle.getRalewayFont(
                  //                             fontSize: 11,
                  //                               fontWeight: FontWeight.w700
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 28),
                  //       customRow("Cybersecurity", cyberSecurity),
                  //       SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: cyberSecurity.length > 2
                  //             ? 2
                  //             : cyberSecurity.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final cyberSecurityItem = cyberSecurity[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 Stack(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(4),
                  //                         topRight: Radius.circular(4),
                  //                       ),
                  //                       child: ImageFiltered(
                  //                         imageFilter: ImageFilter.blur(
                  //                           sigmaX: 1,
                  //                           sigmaY: 1,
                  //                         ),
                  //                         child: Image.asset(
                  //                           cyberSecurityItem["image"] ??
                  //                               LocalImages.trainingImage,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Column(
                  //                       children: [
                  //                         SizedBox(height: 30),
                  //                         Center(
                  //                           child: Text(
                  //                             cyberSecurityItem["title"] ?? "",
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 8,
                  //                               fontWeight: FontWeight.w600,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Center(
                  //                           child: Text(
                  //                             cyberSecurityItem["subTitle"] ?? "",
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 8,
                  //                               fontWeight: FontWeight.w500,
                  //                             ),
                  //                             textAlign: TextAlign.center,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     cyberSecurityItem["name"] ?? "",
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 GestureDetector(
                  //                   onTap: (){
                  //                     Navigation.push(context, AddToTrainingScreen());
                  //                   },
                  //                   child: Container(
                  //                     width: 120,
                  //                     height: 32,
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.blueAccent,
                  //                       borderRadius: BorderRadius.circular(6),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         "ADD TRAINING",
                  //                         style: CommonStyle.getRalewayFont(
                  //                           fontSize: 11,
                  //                             fontWeight: FontWeight.w700
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 28),
                  //       customRow("Shipboard Operations", shipBoardOperations),
                  //       SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: shipBoardOperations.length > 2
                  //             ? 2
                  //             : shipBoardOperations.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final shipBoardOperation = shipBoardOperations[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 Stack(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(4),
                  //                         topRight: Radius.circular(4),
                  //                       ),
                  //                       child: ImageFiltered(
                  //                         imageFilter: ImageFilter.blur(
                  //                           sigmaX: 1,
                  //                           sigmaY: 1,
                  //                         ),
                  //                         child: Image.asset(
                  //                           shipBoardOperation["image"] ??
                  //                               LocalImages.trainingImage2,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Column(
                  //                       children: [
                  //                         SizedBox(height: 20),
                  //                         Center(
                  //                           child: Text(
                  //                             shipBoardOperation["title"],
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 4,
                  //                               fontWeight: FontWeight.w600,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         SizedBox(height: 14),
                  //                         Center(
                  //                           child: Text(
                  //                             shipBoardOperation["subTitle"],
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 8,
                  //                               fontWeight: FontWeight.w800,
                  //                             ),
                  //                             textAlign: TextAlign.center,
                  //                           ),
                  //                         ),
                  //                         Center(
                  //                           child: Text(
                  //                             shipBoardOperation["subMenuTitle"],
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 8,
                  //                               fontWeight: FontWeight.w500,
                  //                             ),
                  //                             textAlign: TextAlign.center,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     shipBoardOperation["name"],
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 GestureDetector(
                  //                   onTap: (){
                  //                     Navigation.push(context, AddToTrainingScreen());
                  //                   },
                  //                   child: Container(
                  //                     width: 120,
                  //                     height: 32,
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.blueAccent,
                  //                       borderRadius: BorderRadius.circular(6),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         "ADD TRAINING",
                  //                         style: CommonStyle.getRalewayFont(
                  //                           fontSize: 11,
                  //                             fontWeight: FontWeight.w700
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 28),
                  //       customRow("Inspections", inspections),
                  //       SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: inspections.length > 2 ? 2 : inspections.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final inspection = inspections[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 Stack(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(4),
                  //                         topRight: Radius.circular(4),
                  //                       ),
                  //                       child: ImageFiltered(
                  //                         imageFilter: ImageFilter.blur(
                  //                           sigmaX: 1,
                  //                           sigmaY: 1,
                  //                         ),
                  //                         child: Image.asset(
                  //                           inspection["image"] ??
                  //                               LocalImages.trainingImage2,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Padding(
                  //                       padding: const EdgeInsets.only(left: 8.0),
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           SizedBox(height: 20),
                  //                           Text(
                  //                             inspection["title"],
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 14,
                  //                               fontWeight: FontWeight.w600,
                  //                             ),
                  //                           ),
                  //                           SizedBox(height: 14),
                  //                           Text(
                  //                             inspection["subTitle"],
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 4,
                  //                               fontWeight: FontWeight.w500,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     inspection["name"],
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 GestureDetector(
                  //                   onTap: (){
                  //                     Navigation.push(context, AddToTrainingScreen());
                  //                   },
                  //                   child: Container(
                  //                     width: 120,
                  //                     height: 32,
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.blueAccent,
                  //                       borderRadius: BorderRadius.circular(6),
                  //                     ),
                  //                     child: Center(
                  //                       child: Text(
                  //                         "ADD TRAINING",
                  //                         style: CommonStyle.getRalewayFont(
                  //                           fontSize: 11,
                  //                             fontWeight: FontWeight.w700
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 28),
                  //       customRow("GDPR", gDPRs),
                  //       SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: gDPRs.length > 2 ? 2 : gDPRs.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final gDPR = gDPRs[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Stack(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(4),
                  //                         topRight: Radius.circular(4),
                  //                       ),
                  //                       child: ImageFiltered(
                  //                         imageFilter: ImageFilter.blur(
                  //                           sigmaX: 1,
                  //                           sigmaY: 1,
                  //                         ),
                  //                         child: Image.asset(
                  //                           gDPR["image"] ??
                  //                               LocalImages.trainingImage2,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     gDPR["name"],
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 Center(
                  //                   child: GestureDetector(
                  //                     onTap: (){
                  //                       Navigation.push(context, AddToTrainingScreen());
                  //                     },
                  //                     child: Container(
                  //                       width: 120,
                  //                       height: 32,
                  //                       decoration: BoxDecoration(
                  //                         color: Colors.blueAccent,
                  //                         borderRadius: BorderRadius.circular(6),
                  //                       ),
                  //                       child: Center(
                  //                         child: Text(
                  //                           "ADD TRAINING",
                  //                           style: CommonStyle.getRalewayFont(
                  //                             fontSize: 11,
                  //                               fontWeight: FontWeight.w700
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 28),
                  //       customRow(
                  //         "Company Specific Training",
                  //         companySpecificTrainings,
                  //       ),
                  //       SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: companySpecificTrainings.length > 2
                  //             ? 2
                  //             : companySpecificTrainings.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final companySpecificTraining =
                  //               companySpecificTrainings[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Stack(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(4),
                  //                         topRight: Radius.circular(4),
                  //                       ),
                  //                       child: ImageFiltered(
                  //                         imageFilter: ImageFilter.blur(
                  //                           sigmaX: 1,
                  //                           sigmaY: 1,
                  //                         ),
                  //                         child: Image.asset(
                  //                           companySpecificTraining["image"] ??
                  //                               LocalImages.trainingImage2,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     companySpecificTraining["name"],
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 Center(
                  //                   child: GestureDetector(
                  //                     onTap: (){
                  //                       Navigation.push(context, AddToTrainingScreen());
                  //                     },
                  //                     child: Container(
                  //                       width: 120,
                  //                       height: 32,
                  //                       decoration: BoxDecoration(
                  //                         color: Colors.blueAccent,
                  //                         borderRadius: BorderRadius.circular(6),
                  //                       ),
                  //                       child: Center(
                  //                         child: Text(
                  //                           "ADD TRAINING",
                  //                           style: CommonStyle.getRalewayFont(
                  //                             fontSize: 11,
                  //                               fontWeight: FontWeight.w700
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 28),
                  //       customRow("Maritime Security", maritimeSecuritys),
                  //       SizedBox(height: 24),
                  //       GridView.builder(
                  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 2,
                  //           crossAxisSpacing: 10,
                  //           childAspectRatio: 0.85,
                  //         ),
                  //         itemCount: maritimeSecuritys.length > 2
                  //             ? 2
                  //             : maritimeSecuritys.length,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           final maritimeSecurity = maritimeSecuritys[index];
                  //           return Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               color: Colors.white,
                  //             ),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Stack(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(4),
                  //                         topRight: Radius.circular(4),
                  //                       ),
                  //                       child: ImageFiltered(
                  //                         imageFilter: ImageFilter.blur(
                  //                           sigmaX: 1,
                  //                           sigmaY: 1,
                  //                         ),
                  //                         child: Image.asset(
                  //                           maritimeSecurity["image"] ??
                  //                               LocalImages.trainingImage2,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Column(
                  //                       mainAxisAlignment: MainAxisAlignment.start,
                  //                       children: [
                  //                         SizedBox(height: 10),
                  //                         Center(
                  //                           child: Text(
                  //                             maritimeSecurity["title"],
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 8,
                  //                               fontWeight: FontWeight.w600,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Center(
                  //                           child: Text(
                  //                             maritimeSecurity["subTitle"],
                  //                             style: CommonStyle.getRalewayFont(
                  //                               fontSize: 4,
                  //                               fontWeight: FontWeight.w500,
                  //                             ),
                  //                             textAlign: TextAlign.center,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 6),
                  //                 Padding(
                  //                   padding: EdgeInsets.symmetric(horizontal: 10),
                  //                   child: Text(
                  //                     maritimeSecurity["name"],
                  //                     style: CommonStyle.getRalewayFont(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.black,
                  //                     ),
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //                 Center(
                  //                   child: GestureDetector(
                  //                     onTap: (){
                  //                       Navigation.push(context, AddToTrainingScreen());
                  //                     },
                  //                     child: Container(
                  //                       width: 120,
                  //                       height: 32,
                  //                       decoration: BoxDecoration(
                  //                         color: Colors.blueAccent,
                  //                         borderRadius: BorderRadius.circular(6),
                  //                       ),
                  //                       child: Center(
                  //                         child: Text(
                  //                           "ADD TRAINING",
                  //                           style: CommonStyle.getRalewayFont(
                  //                             fontSize: 11,
                  //                               fontWeight: FontWeight.w700
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 10),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //       SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerScreen(),
    );
  }

  // Widget customRow(String title, List<Map> data, {double? fontSize}) {
  //   List<Map> dataWithHeading = List.from(data);
  //   if (dataWithHeading.isNotEmpty &&
  //       !dataWithHeading[0].containsKey("heading")) {
  //     dataWithHeading[0] = Map.from(dataWithHeading[0]);
  //     dataWithHeading[0]["heading"] = title;
  //   }
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Expanded(
  //         child: Text(
  //           title ?? "",
  //           style: CommonStyle.getRalewayFont(
  //             fontSize: fontSize ?? 18,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.black,
  //           ),
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           Navigation.push(
  //             context,
  //             ViewAllTrainingScreen(data: dataWithHeading),
  //           );
  //         },
  //         child: Text(
  //           "See all",
  //           style: CommonStyle.getRalewayFont(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color: AppColors.lightBlue,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget buildVideoGrid() {
  //   return ListView.builder(
  //     itemCount: mViewModel?.video?.length ?? 0,
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemBuilder: (context, categoryIndex) {
  //       final category = mViewModel!.video![categoryIndex];
  //       final videosToShow = category.videoList?.take(2).toList() ?? [];
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Category Header with "See all"
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: Text(
  //                     category.category ?? "",
  //                     style: CommonStyle.getRalewayFont(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.black,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigation.push(
  //                       context,
  //                       ViewAllTrainingScreen(
  //                         data: category.videoList ?? [],
  //                         categoryTitle: category.category ?? "",
  //                       ),
  //                     );
  //                   },
  //                   child: Text(
  //                     "See all",
  //                     style: CommonStyle.getRalewayFont(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                       color: AppColors.lightBlue,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16),
  //             child: GridView.builder(
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2,
  //                 crossAxisSpacing: 12,
  //                 mainAxisSpacing: 12,
  //                 childAspectRatio: 0.75,
  //               ),
  //               itemCount: videosToShow.length,
  //               shrinkWrap: true,
  //               physics: NeverScrollableScrollPhysics(),
  //               itemBuilder: (context, videoIndex) {
  //                 final video = videosToShow[videoIndex];
  //
  //                 return Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: Colors.white,
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.grey.withOpacity(0.1),
  //                         spreadRadius: 1,
  //                         blurRadius: 4,
  //                         offset: Offset(0, 2),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // Video Thumbnail
  //                       Expanded(
  //                         flex: 3,
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(8),
  //                             topRight: Radius.circular(8),
  //                           ),
  //                           child: Container(
  //                             width: double.infinity,
  //                             child: video.image != null
  //                                 ? Image.network(
  //                                     video.image!,
  //                                     fit: BoxFit.cover,
  //                                     errorBuilder:
  //                                         (context, error, stackTrace) {
  //                                           return Image.asset(
  //                                             LocalImages.trainingImage,
  //                                             fit: BoxFit.cover,
  //                                           );
  //                                         },
  //                                   )
  //                                 : Image.asset(
  //                                     LocalImages.trainingImage,
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                           ),
  //                         ),
  //                       ),
  //
  //                       // Video Details
  //                       Expanded(
  //                         flex: 2,
  //                         child: Padding(
  //                           padding: EdgeInsets.all(12),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               // Title
  //                               Text(
  //                                 video.title ?? "",
  //                                 style: CommonStyle.getRalewayFont(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Colors.black,
  //                                 ),
  //                                 maxLines: 2,
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //
  //                               Spacer(),
  //
  //                               // Add Training Button
  //                               GestureDetector(
  //                                 onTap: () {
  //                                   Navigation.push(
  //                                     context,
  //                                     AddToTrainingScreen(videoData: video),
  //                                   );
  //                                 },
  //                                 child: Container(
  //                                   width: double.infinity,
  //                                   height: 32,
  //                                   decoration: BoxDecoration(
  //                                     color: AppColors.primaryBlue,
  //                                     borderRadius: BorderRadius.circular(6),
  //                                   ),
  //                                   child: Center(
  //                                     child: Text(
  //                                       "ADD TRAINING",
  //                                       style: CommonStyle.getRalewayFont(
  //                                         fontSize: 10,
  //                                         fontWeight: FontWeight.w700,
  //                                         color: Colors.white,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //
  //           SizedBox(height: 24),
  //         ],
  //       );
  //     },
  //   );
  // }
}
