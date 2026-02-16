class PrivacyPolicyModel {
  bool? status;
  PrivacyPolicy? privacyPolicy;

  PrivacyPolicyModel({this.status, this.privacyPolicy});

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    privacyPolicy = json['privacy_policy'] != null
        ? new PrivacyPolicy.fromJson(json['privacy_policy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.privacyPolicy != null) {
      data['privacy_policy'] = this.privacyPolicy!.toJson();
    }
    return data;
  }
}

class PrivacyPolicy {
  int? id;
  String? title1;
  String? description1;
  String? image1;
  String? title2;
  String? description2;
  String? image2;
  String? video;
  Null? ourmissionquote;
  Null? ourmissionauthor;
  Null? image3;
  Null? image4;
  String? createdAt;
  String? updatedAt;

  PrivacyPolicy(
      {this.id,
        this.title1,
        this.description1,
        this.image1,
        this.title2,
        this.description2,
        this.image2,
        this.video,
        this.ourmissionquote,
        this.ourmissionauthor,
        this.image3,
        this.image4,
        this.createdAt,
        this.updatedAt});

  PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title1 = json['title1'];
    description1 = json['description1'];
    image1 = json['image1'];
    title2 = json['title2'];
    description2 = json['description2'];
    image2 = json['image2'];
    video = json['video'];
    ourmissionquote = json['ourmissionquote'];
    ourmissionauthor = json['ourmissionauthor'];
    image3 = json['image3'];
    image4 = json['image4'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title1'] = this.title1;
    data['description1'] = this.description1;
    data['image1'] = this.image1;
    data['title2'] = this.title2;
    data['description2'] = this.description2;
    data['image2'] = this.image2;
    data['video'] = this.video;
    data['ourmissionquote'] = this.ourmissionquote;
    data['ourmissionauthor'] = this.ourmissionauthor;
    data['image3'] = this.image3;
    data['image4'] = this.image4;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
