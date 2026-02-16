import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/database/app_preferences.dart';
import 'package:marine_media_enterprises/screens/drawer_screen.dart';
import 'package:marine_media_enterprises/screens/login/user_model.dart';
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

  AppPreferences appPreferences = AppPreferences();
  User? user;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    user = await appPreferences.getUserDetails();
    print("user data in profile screen ${user?.toJson()}");
    nameController.text = user?.firstName ?? "-";
    surNameController.text = user?.lastName ?? "-";
    dateOfBirthController.text = user?.birthday ?? "-";
    vesselNameController.text = user?.vesselName ?? "-";
    emailController.text = user?.email ?? "-";
    mobileController.text = user?.number ?? "-";
    print(user);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            child: Icon(Icons.menu, color: Colors.white, size: 30),
          ),
          title: Text(
            "My Profile",
            style: CommonStyle.getRalewayFont(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : Column(
                children: [
                  Image.asset(LocalImages.logo, scale: 4),
                  SizedBox(height: 8),
                  Center(
                    child: user?.profilePhoto != null
                        ? Image.network(
                            user!.profilePhoto!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 260,
                          )
                        : Image.asset(
                            LocalImages.userImage,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    user?.email ?? "",
                    style: CommonStyle.getRalewayFont(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Stack(
                      children: [
                        Image.asset(
                          LocalImages.backgroundImage2,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              buildProfileField("Name", nameController),
                              buildProfileField("Surname", surNameController),
                              buildProfileField(
                                "Date of Birth",
                                dateOfBirthController,
                              ),
                              buildProfileField(
                                "Vessel Name",
                                vesselNameController,
                              ),
                              buildProfileField(
                                "Email Address",
                                emailController,
                              ),
                              buildProfileField(
                                "Mobile Number",
                                mobileController,
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildProfileField(String label, TextEditingController controller) {
    return Container(
      height: 75,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 10),
            child: Text(
              label,
              style: CommonStyle.getRalewayFont(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 10),
          CustomTextfield(
            readOnly: true,
            textController: controller,
            // hintText: label,
            textFieldHeight: 10,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
