import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/accouunt_setting_screen.dart';
import 'package:marine_media_enterprises/screens/my_training_screen.dart';
import 'package:marine_media_enterprises/screens/profile_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/app_strings/app_strings.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Drawer(
        backgroundColor: AppColors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: AppColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text(AppStrings.appName, style: CommonStyle.getRalewayFont(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonTile("Home", () {}),
                    commonTile("My Profile", () {Navigation.push(context, ProfileScreen());}),
                    commonTile("My Training", () {Navigation.push(context, MyTrainingScreen());}),
                    commonTile("Account Setting", () {Navigation.push(context, AccouuntSettingScreen());}),
                    commonTile("Download", () {}),
                    commonTile("Term & Condition", () {}),
                    commonTile("Privacy Policy", () {}),
                    commonTile("Sign Out", () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonTile(String text, GestureTapCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Text(
            text,
            style: CommonStyle.getRalewayFont(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
