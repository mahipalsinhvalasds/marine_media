import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/add_to_training/add_training_view_model.dart';
import 'package:marine_media_enterprises/screens/home/training_model.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:provider/provider.dart';

class AddToTrainingScreen extends StatefulWidget {
  final VideoList? video;
  const AddToTrainingScreen({super.key, required this.video});

  @override
  State<AddToTrainingScreen> createState() => _AddToTrainingScreenState();
}

class _AddToTrainingScreenState extends State<AddToTrainingScreen> {
  AddTrainingApiViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = Provider.of<AddTrainingApiViewModel>(context,listen: false);
    mViewModel?.init(context);
  }
  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<AddTrainingApiViewModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            LocalImages.backgroundImageBlue,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigation.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Center(child: Image.asset(LocalImages.logo, scale: 4)),
                      SizedBox(height: 14),
                      Text(
                        widget.video?.title ?? "",
                        style: CommonStyle.getRalewayFont(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        widget.video?.description ?? "",
                        style: CommonStyle.getRalewayFont(
                          height: 2.3,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Length: ",
                            style: CommonStyle.getRalewayFont(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.video?.duration ?? "",
                            style: CommonStyle.getRalewayFont(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Audio: ",
                            style: CommonStyle.getRalewayFont(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "EN",
                            style: CommonStyle.getRalewayFont(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Subtitles: ",
                            style: CommonStyle.getRalewayFont(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.video?.subTitle ?? "",
                            style: CommonStyle.getRalewayFont(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Categories: ",
                            style: CommonStyle.getRalewayFont(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.video?.category ?? "",
                              style: CommonStyle.getRalewayFont(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(18),
        height: 85,
        color: AppColors.grey2,
        child: CustomButton(
          text: "Add to My Training",
          fontWeight: FontWeight.w400,
          fontSize: 14,
          loading: mViewModel?.loading ?? false,
          onTap: (){
            if(widget.video?.categoryId != null && widget.video?.id != null){
              mViewModel?.onAddTrainingTap(widget.video!.categoryId!, widget.video!.id!);
            }
          },
        ),
      ),
    );
  }
}
