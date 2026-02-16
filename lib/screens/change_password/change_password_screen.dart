import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/change_password/change_password_view_model.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/common_methods/common_methods.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/utils/validation.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isValidationActivated = false;

  ChangePasswordViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = Provider.of<ChangePasswordViewModel>(context, listen: false);
    mViewModel?.init(context);
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<ChangePasswordViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigation.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Change Password",
          style: CommonStyle.getRalewayFont(
            fontSize: 22,
            fontWeight: FontWeight.w600,
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
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Image.asset(
                        LocalImages.logo,
                        color: AppColors.grey,
                        scale: 4,
                      ),
                    ),
                    SizedBox(height: 70),
                    CustomTextfield(
                      textController: currentPasswordController,
                      hintText: "Current Password",
                      onChanged: (value) {
                        if (isValidationActivated) {
                          formKey.currentState!.validate();
                        }
                      },
                      validation: (value) =>
                          CustomValidations.changePasswordValidator(value),
                    ),
                    CustomTextfield(
                      textController: newPasswordController,
                      hintText: "New Password",
                      onChanged: (value) {
                        if (isValidationActivated) {
                          formKey.currentState!.validate();
                        }
                      },
                      validation: (value) =>
                          CustomValidations.changePasswordValidator(value),
                    ),
                    CustomTextfield(
                      textController: confirmNewPasswordController,
                      hintText: "Confirm New Password",
                      onChanged: (value) {
                        if (isValidationActivated) {
                          formKey.currentState!.validate();
                        }
                      },
                      validation: (value) =>
                          CustomValidations.changePasswordValidator(value),
                    ),
                    CustomButton(
                      text: "Update",
                      backgroundColor: AppColors.backgroundColor,
                      border: Border(),
                      loading: mViewModel?.loading ?? false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (confirmNewPasswordController.text.trim() !=
                              newPasswordController.text.trim()) {
                            CommonMethods.showCustomSnackBar(
                              context: context,
                              text: "New Password and Confirm New Password must be same",
                            );
                            return;
                          }
                          mViewModel?.onChangePassword(
                            currentPasswordController.text.trim(),
                            newPasswordController.text.trim(),
                            confirmNewPasswordController.text.trim(),
                          );
                        } else {
                          setState(() {
                            isValidationActivated = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
