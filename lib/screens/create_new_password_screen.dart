import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
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
            "Change Password",
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
                    SizedBox(height: 50),
                    Center(child: Image.asset(LocalImages.logo,color: AppColors.grey,scale: 4,)),
                    SizedBox(height: 70),
                   CustomTextfield(hintText: "Current Password"),
                   CustomTextfield(hintText: "New Password"),
                   CustomTextfield(hintText: "Confirm New Password"),
                    CustomButton(text: "Update",backgroundColor: AppColors.backgroundColor,border: Border(),),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
