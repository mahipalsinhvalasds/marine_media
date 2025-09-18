import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';

class MyTrainingScreen extends StatefulWidget {
  const MyTrainingScreen({super.key});

  @override
  State<MyTrainingScreen> createState() => _MyTrainingScreenState();
}

class _MyTrainingScreenState extends State<MyTrainingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  final List<Map> onGoings = [
    {
      "title": "Crew Welfare",
      "subTitle": "Bullying and Harassment Series - Part 2-",
    },
    {
      "title": "Crew Welfare",
      "subTitle": "Bullying and Harassment Series - Part 3-",
    },
    {"title": "Crew Welfare", "subTitle": "Drug Smuggling at Sea"},
    {"title": "Company Specific Training", "subTitle": "Company Specific 1"},
    {
      "title": "Shipboard Operations",
      "subTitle": "Observation Skills & Incident Reporting",
    },
    {
      "title": "Shipboard Operation",
      "subTitle": "Management onboard - Programme 3",
    },
  ];
  final List<Map> completeds = [
    {
      "title": "Crew Welfare",
      "subTitle": "Enclosed Spaces are Dangerous Places",
    },
    {
      "title": "Crew Welfare",
      "subTitle": "Bullying and Harassment Series - Part 1-",
    },
    {
      "title": "Shipboard Operations",
      "subTitle": "Understanding Permit to Work System",
    },
    {
      "title": "SCrew Welfare",
      "subTitle": "Drug & Alcohol Abuse",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(Icons.menu, color: Colors.white),
        ),
        title: Text(
          "My Training",
          style: CommonStyle.getRalewayFont(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                height: 40,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Container(
                          color: selectedIndex == 0
                              ? AppColors.grey
                              : Colors.white,
                          child: Center(
                            child: Text(
                              "Ongoing",
                              style: CommonStyle.getRalewayFont(
                                color: selectedIndex == 0
                                    ? Colors.white
                                    : AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Container(
                          color: selectedIndex == 1
                              ? AppColors.grey
                              : Colors.white,
                          child: Center(
                            child: Text(
                              "Completed",
                              style: CommonStyle.getRalewayFont(
                                color: selectedIndex == 1
                                    ? Colors.white
                                    : AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              selectedIndex == 0
                  ? ListView.builder(
                      itemCount: onGoings.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final onGoing = onGoings[index];
                        return Stack(
                          children: [
                            Container(
                              height: 160,
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.black,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  LocalImages.sea,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: SizedBox(
                                      height: 24,
                                      width: 30,
                                      child: Icon(
                                        Icons.more_horiz,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        onGoing["title"],
                                        style: CommonStyle.getRalewayFont(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          onGoing["subTitle"],
                                          style: CommonStyle.getRalewayFont(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "START TRAINING",
                                            style: CommonStyle.getRalewayFont(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    )
                  : ListView.builder(
                itemCount: completeds.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final completed = completeds[index];
                  return Stack(
                    children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            LocalImages.sea,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                height: 24,
                                width: 30,
                                child: Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  completed["title"],
                                  style: CommonStyle.getRalewayFont(
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    completed["subTitle"],
                                    style: CommonStyle.getRalewayFont(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "START TRAINING",
                                      style: CommonStyle.getRalewayFont(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
