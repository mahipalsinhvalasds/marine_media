import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/term_condition/term_condition_view_model.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TermConditionScreen extends StatefulWidget {
  const TermConditionScreen({super.key});

  @override
  State<TermConditionScreen> createState() => _TermConditionScreenState();
}

class _TermConditionScreenState extends State<TermConditionScreen> {
  TermConditionViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = Provider.of<TermConditionViewModel>(context,listen: false);
    mViewModel?.init(context);
  }
  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<TermConditionViewModel>(context);
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
          "Term & Condition",
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
          mViewModel?.loading == true
              ? Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  SizedBox(height: 10),
                  Text(
                    mViewModel?.termConditionModel?.termCondition?.title1 ?? "Term & Conditions",
                    style: CommonStyle.getRalewayFont(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
                  HtmlWidget(
                    mViewModel?.termConditionModel?.termCondition?.description1 ?? "",
                    textStyle: CommonStyle.getRalewayFont(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      height: 1.8,
                    ),
                    customStylesBuilder: (element) {
                      if (element.localName == 'strong' || element.localName == 'b') {
                        return {
                          'font-weight': 'bold',
                        };
                      }
                      if (element.localName == 'h1') {
                        return {
                          'font-size': '24px',
                          'font-weight': 'bold',
                          'margin-bottom': '16px',
                        };
                      }
                      if (element.localName == 'h2') {
                        return {
                          'font-size': '20px',
                          'font-weight': 'bold',
                          'margin-bottom': '12px',
                        };
                      }
                      if (element.localName == 'a') {
                        return {
                          'color': '#77aee0',
                          'text-decoration': 'underline',
                          'text-decoration-color': '#77aee0',
                          'font-weight': '500',
                        };
                      }
                      return null;
                    },
                    onTapUrl: (url) async {
                      try {
                        final Uri uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                          return true;
                        } else {
                          print('Could not launch $url');
                          return false;
                        }
                      } catch (e) {
                        print('Error launching URL: $e');
                        return false;
                      }
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
