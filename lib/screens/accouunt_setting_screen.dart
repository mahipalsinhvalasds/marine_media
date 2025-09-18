import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class AccouuntSettingScreen extends StatefulWidget {
  const AccouuntSettingScreen({super.key});

  @override
  State<AccouuntSettingScreen> createState() => _AccouuntSettingScreenState();
}

class _AccouuntSettingScreenState extends State<AccouuntSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
            onTap: (){
              Navigation.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(
          "Account Setting",
          style: CommonStyle.getRalewayFont(fontSize: 22,fontWeight: FontWeight.w500),
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
                  Center(child: Image.asset(LocalImages.logo,color: AppColors.grey,scale: 4,)),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Change Password",
                          style: CommonStyle.getRalewayFont(
                            color: Colors.black,
                            fontSize: 16
                          ),
                        ),
                        Spacer(),
                        Icon((Icons.keyboard_arrow_right_rounded)),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
