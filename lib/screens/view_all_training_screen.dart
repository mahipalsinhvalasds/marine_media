import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/add_to_training/add_to_training_screen.dart';
import 'package:marine_media_enterprises/screens/home/training_model.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class ViewAllTrainingScreen extends StatefulWidget {
  final Video? data;
  const ViewAllTrainingScreen({super.key, required this.data});

  @override
  State<ViewAllTrainingScreen> createState() => _ViewAllTrainingScreenState();
}

class _ViewAllTrainingScreenState extends State<ViewAllTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigation.pop(context);
          },
          child: Icon(Icons.highlight_remove, color: Colors.white, size: 30),
        ),
        title: Text(
          widget.data?.category ?? "",
          style: CommonStyle.getRalewayFont(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(LocalImages.icSearch, height: 24),
          ),
        ],
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
                  SizedBox(height: 40),
                  GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: widget.data?.videoList?.length ?? 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final video = widget.data?.videoList?[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                    child: video?.image != null
                                        ? Image.network(
                                      video?.image ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          LocalImages.trainingImage,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                        : Image.asset(
                                      LocalImages.trainingImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  video?.title ?? "",
                                  style: CommonStyle.getRalewayFont(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigation.push(
                                      context,
                                      AddToTrainingScreen(video: video,),
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(
                                        6,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "ADD TRAINING",
                                        style: CommonStyle.getRalewayFont(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

  Widget _buildTrainingCard(Map data) {
    String sectionType = _getSectionType(data);

    switch (sectionType) {
      case 'interpersonal':
        return _buildInterpersonalCard(data);
      case 'bridge':
        return _buildBridgeCard(data);
      case 'crew_welfare':
        return _buildCrewWelfareCard(data);
      case 'mental_health':
        return _buildMentalHealthCard(data);
      case 'cybersecurity':
        return _buildCybersecurityCard(data);
      case 'shipboard':
        return _buildShipboardCard(data);
      case 'inspections':
        return _buildInspectionsCard(data);
      case 'gdpr':
        return _buildGDPRCard(data);
      case 'company':
        return _buildCompanyCard(data);
      case 'maritime':
        return _buildMaritimeCard(data);
      default:
        return _buildDefaultCard(data);
    }
  }

  String _getSectionType(Map data) {
    if (data["heading"] != null) {
      String heading = data["heading"].toString().toLowerCase();
      if (heading.contains('interpersonal')) return 'interpersonal';
      if (heading.contains('bridge')) return 'bridge';
      if (heading.contains('crew')) return 'crew_welfare';
      if (heading.contains('mental')) return 'mental_health';
      if (heading.contains('cyber')) return 'cybersecurity';
      if (heading.contains('shipboard')) return 'shipboard';
      if (heading.contains('inspection')) return 'inspections';
      if (heading.contains('gdpr')) return 'gdpr';
      if (heading.contains('company')) return 'company';
      if (heading.contains('maritime')) return 'maritime';
    }

    // Fallback based on data structure
    if (data["isBox"] != null) return 'crew_welfare';
    if (data["subMenuTitle"] != null) return 'shipboard';
    if (data["title"] != null && data["subTitle"] != null)
      return 'interpersonal';

    return 'default';
  }

  Widget _buildInterpersonalCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Image.asset(
                    data["image"] ?? LocalImages.trainingImage,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      data["title"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      data["subTitle"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                "ADD TRAINING",
                style: CommonStyle.getRalewayFont(fontSize: 11),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildBridgeCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            child: Image.asset(data["image"] ?? LocalImages.trainingImage2),
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                "ADD TRAINING",
                style: CommonStyle.getRalewayFont(fontSize: 11),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCrewWelfareCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: data["isBlur"] == true
                    ? ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Image.asset(
                          data["image"] ?? LocalImages.trainingImage,
                        ),
                      )
                    : ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Image.asset(
                          data["image"] ?? LocalImages.trainingImage,
                        ),
                      ),
              ),
              Column(
                children: [
                  SizedBox(height: 30),
                  data["isBox"] == true
                      ? Center(
                          child: Container(
                            height: 30,
                            width: 100,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              color: Colors.black.withOpacity(0.8),
                            ),
                            child: Text(
                              data["title"] ?? "",
                              style: CommonStyle.getRalewayFont(
                                fontSize: 6,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            data["title"] ?? "",
                            style: CommonStyle.getRalewayFont(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 120,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "ADD TRAINING",
                  style: CommonStyle.getRalewayFont(fontSize: 11),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMentalHealthCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: Image.asset(data["image"] ?? LocalImages.trainingImage),
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 120,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "ADD TRAINING",
                  style: CommonStyle.getRalewayFont(fontSize: 11),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCybersecurityCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Image.asset(
                    data["image"] ?? LocalImages.trainingImage,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      data["title"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      data["subTitle"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                "ADD TRAINING",
                style: CommonStyle.getRalewayFont(fontSize: 11),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildShipboardCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Image.asset(
                    data["image"] ?? LocalImages.trainingImage2,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      data["title"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Center(
                    child: Text(
                      data["subTitle"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      data["subMenuTitle"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                "ADD TRAINING",
                style: CommonStyle.getRalewayFont(fontSize: 11),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInspectionsCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Image.asset(
                    data["image"] ?? LocalImages.trainingImage2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      data["title"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      data["subTitle"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                "ADD TRAINING",
                style: CommonStyle.getRalewayFont(fontSize: 11),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildGDPRCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Image.asset(
                    data["image"] ?? LocalImages.trainingImage2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 120,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "ADD TRAINING",
                  style: CommonStyle.getRalewayFont(fontSize: 11),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Image.asset(
                    data["image"] ?? LocalImages.trainingImage2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 120,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "ADD TRAINING",
                  style: CommonStyle.getRalewayFont(fontSize: 11),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMaritimeCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Image.asset(LocalImages.trainingImage2),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      data["title"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      data["subTitle"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 4,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 120,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "ADD TRAINING",
                  style: CommonStyle.getRalewayFont(fontSize: 11),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDefaultCard(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Image.asset(LocalImages.trainingImage),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      data["title"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      data["subTitle"] ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              data["name"] ?? "",
              style: CommonStyle.getRalewayFont(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                "ADD TRAINING",
                style: CommonStyle.getRalewayFont(fontSize: 11),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
