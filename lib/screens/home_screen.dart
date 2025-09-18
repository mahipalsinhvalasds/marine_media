import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/screens/drawer_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(Icons.menu, color: Colors.white),
        ),
        title: Text(
          "View Traning",
          style: CommonStyle.getRalewayFont(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(LocalImages.icSearch, height: 24),
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
          Column(
            children: [
              SizedBox(height: 20),
              Center(child: Image.asset(LocalImages.logo,color: AppColors.grey,scale: 4,)),
              SizedBox(height: 40),
            ],
          )
        ],
      ),
      drawer: DrawerScreen(),
    );
  }
}
