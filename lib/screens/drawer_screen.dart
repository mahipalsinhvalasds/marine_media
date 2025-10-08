import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/database/app_preferences.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/accouunt_setting_screen.dart';
import 'package:marine_media_enterprises/screens/download_screen.dart';
import 'package:marine_media_enterprises/screens/home/home_screen.dart';
import 'package:marine_media_enterprises/screens/login/login_screen.dart';
import 'package:marine_media_enterprises/screens/my_training/my_training_screen.dart';
import 'package:marine_media_enterprises/screens/privacy_policy_screen.dart';
import 'package:marine_media_enterprises/screens/profile_screen.dart';
import 'package:marine_media_enterprises/screens/signup_screen.dart';
import 'package:marine_media_enterprises/screens/term_condition_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/app_strings/app_strings.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  AppPreferences appPreferences = AppPreferences();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Drawer(
        backgroundColor: AppColors.grey2,
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
                height: 140,
                width: double.infinity,
                color: AppColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Image.asset(LocalImages.marineMediaLogo),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonTile("Home", () {
                      Navigation.push(context, HomeScreen());
                    }),
                    commonTile("My Profile", () {
                      Navigation.push(context, ProfileScreen());
                    }),
                    commonTile("My Training", () {
                      Navigation.push(context, MyTrainingScreen());
                    }),
                    commonTile("Account Setting", () {
                      Navigation.push(context, AccouuntSettingScreen());
                    }),
                    commonTile("Download", () {
                      Navigation.push(context, DownloadScreen());
                    }),
                    commonTile("Term & Condition", () {
                      Navigation.push(context, TermConditionScreen());
                    }),
                    commonTile("Privacy Policy", () {
                      Navigation.push(context, PrivacyPolicyScreen());
                    }),
                    commonTile("Sign Out", () async {
                      await appPreferences.removeUserDetails();
                      await appPreferences.removeUserLogin();
                      Navigation.removeAllPreviousAndPush(
                        context,
                        LoginScreen(),
                      );
                    }),
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
