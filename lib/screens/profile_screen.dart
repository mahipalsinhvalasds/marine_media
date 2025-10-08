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

  getData() {
    nameController.text = "Paul";
    surNameController.text = "Ricardo";
    dateOfBirthController.text = "01/06/1996";
    vesselNameController.text = "dd34";
    emailController.text = "ricardo.paul@gmail.com";
    mobileController.text = "6547898747";
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
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Image.asset(LocalImages.logo, scale: 4),
            SizedBox(height: 15),
            Center(child: Image.asset(LocalImages.userImage, height: 100)),
            SizedBox(height: 18),
            Text(
              "ricardo.paul@gmail.com",
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
                        buildProfileField("Vessel Name", vesselNameController),
                        buildProfileField("Email Address", emailController),
                        buildProfileField("Mobile Number", mobileController),
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
      height: 70,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, top: 10),
            child: Text(
              label,
              style: CommonStyle.getRalewayFont(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CustomTextfield(
            textController: controller,
            hintText: label,
            textFieldHeight: 22,
          ),
        ],
      ),
    );
  }
}
