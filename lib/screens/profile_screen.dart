import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/screens/drawer_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController vesselNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData(){
    nameController.text = "Paul";
    surNameController.text = "Ricardo";
    dateOfBirthController.text = "01/06/1996";
    vesselNameController.text = "dd34";
    emailController.text = "ricardo.paul@gmail.com";
    mobileController.text = "6547898747";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      drawer: DrawerScreen(),
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
          "My Profile",
          style: CommonStyle.getRalewayFont(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(child: Image.asset(LocalImages.userImage, height: 80)),
            SizedBox(height: 50),
            Container(
              height: 50,
              color: AppColors.backgroundColor,
              child: Text(
                "ricardo.paul@gmail.com",
                style: CommonStyle.getRalewayFont(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 96,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14, top: 10),
                            child: Text(
                              "Name",
                              style: CommonStyle.getRalewayFont(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          CustomTextfield(
                            textController: nameController,
                            hintText: "Name",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 96,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14, top: 10),
                            child: Text(
                              "Surname",
                              style: CommonStyle.getRalewayFont(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          CustomTextfield(
                            textController: surNameController,
                            hintText: "Surname",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 96,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14, top: 10),
                            child: Text(
                              "Date of Birth",
                              style: CommonStyle.getRalewayFont(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          CustomTextfield(
                            textController: dateOfBirthController,
                            hintText: "Date of Birth",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 96,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14, top: 10),
                            child: Text(
                              "Vessel Name",
                              style: CommonStyle.getRalewayFont(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          CustomTextfield(
                            textController: vesselNameController,
                            hintText: "Vessel Name",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 96,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14, top: 10),
                            child: Text(
                              "Email Address",
                              style: CommonStyle.getRalewayFont(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          CustomTextfield(
                            textController: emailController,
                            hintText: "Email Address",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 96,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14, top: 10),
                            child: Text(
                              "Mobile Number",
                              style: CommonStyle.getRalewayFont(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          CustomTextfield(
                            textController: mobileController,
                            hintText: "Mobile Number",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
