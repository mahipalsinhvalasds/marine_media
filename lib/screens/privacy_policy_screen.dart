import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Privacy Policy",
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      LocalImages.logo,
                      color: AppColors.grey,
                      scale: 4,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    "Privacy Policy",
                    style: CommonStyle.getRalewayFont(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "BACKGROUND:",
                    style: CommonStyle.getRalewayFont(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
