import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/drawer_screen.dart';
import 'package:marine_media_enterprises/screens/my_training/my_training_view_model.dart';
import 'package:marine_media_enterprises/screens/start_training/start_training_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:provider/provider.dart';

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
    {"title": "SCrew Welfare", "subTitle": "Drug & Alcohol Abuse"},
  ];

  MyTrainingViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mViewModel = Provider.of<MyTrainingViewModel>(context, listen: false);
      mViewModel?.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<MyTrainingViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white70,
      key: _scaffoldKey,
      drawer: DrawerScreen(),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(Icons.menu, color: Colors.white, size: 30),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Center(
                    child: Image.asset(
                      LocalImages.logo,
                      color: AppColors.grey,
                      scale: 4,
                    ),
                  ),
                  SizedBox(height: 10),
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
                              mViewModel?.getTrainingDetails(0);
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
                              mViewModel?.getTrainingDetails(1);
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
                  if (mViewModel?.loading == true)
                    Center(child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    ))
                  else if ((mViewModel?.video?.isEmpty ?? true))
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          "No trainings found",
                          style: CommonStyle.getRalewayFont(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  else
                    (selectedIndex == 0
                        ? ListView.builder(
                            itemCount: mViewModel?.video?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final onGoing = mViewModel?.video?[index];
                              return Stack(
                                children: [
                                  Container(
                                    height: 160,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                    ),

                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: onGoing?.image != null
                                          ? Image.network(
                                              onGoing!.image!,
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
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTapDown: (TapDownDetails details) {
                                            final Offset tapPosition = details.globalPosition;
                                            showMenu(
                                              context: context,
                                              position: RelativeRect.fromLTRB(
                                                tapPosition.dx - 80,
                                                tapPosition.dy + 5,
                                                MediaQuery.of(context).size.width - tapPosition.dx - 80,
                                                MediaQuery.of(context).size.height - tapPosition.dy - 5,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              menuPadding: EdgeInsets.zero,
                                              elevation: 8,
                                              items: [
                                                PopupMenuItem(
                                                  value: 'remove',
                                                  padding: EdgeInsets.zero,
                                                  height: 30,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      Navigation.pop(context);
                                                      mViewModel?.deleteMyTraining(onGoing?.id ?? 0);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.delete_outline,
                                                          color: Colors.black,
                                                          size: 22,
                                                        ),
                                                        SizedBox(width: 12),
                                                        Text(
                                                          'Remove',
                                                          style: CommonStyle.getRalewayFont(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w300,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
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
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
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
                                              onGoing?.category ?? "",
                                              style: CommonStyle.getRalewayFont(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 6,
                                              ),
                                              child: Text(
                                                onGoing?.title ?? "",
                                                style: CommonStyle.getRalewayFont(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () {
                                                Navigation.push(
                                                  context,
                                                  StartTrainingScreen(video: onGoing,),
                                                );
                                              },
                                              child: Container(
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
                                                      fontWeight: FontWeight.w700,
                                                    ),
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
                            itemCount: mViewModel?.video?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final completed = mViewModel?.video?[index];
                              return Stack(
                                children: [
                                  Container(
                                    height: 160,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: completed?.image != null
                                          ? Image.network(
                                              completed!.image!,
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
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
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
                                              completed?.category ?? "",
                                              style: CommonStyle.getRalewayFont(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 6,
                                              ),
                                              child: Text(
                                                completed?.title ?? "",
                                                style: CommonStyle.getRalewayFont(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Icon(
                                              Icons.check_circle,
                                              size: 30,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
