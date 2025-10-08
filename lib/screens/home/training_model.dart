class TrainingModel {
  bool? status;
  List<Video>? video;

  TrainingModel({this.status, this.video});

  TrainingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['video'] != null) {
      video = <Video>[];
      json['video'].forEach((v) {
        video!.add(new Video.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.video != null) {
      data['video'] = this.video!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Video {
  int? categoryId;
  String? category;
  List<VideoList>? videoList;

  Video({this.categoryId, this.category, this.videoList});

  Video.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    category = json['category'];
    if (json['video_list'] != null) {
      videoList = <VideoList>[];
      json['video_list'].forEach((v) {
        videoList!.add(new VideoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    if (this.videoList != null) {
      data['video_list'] = this.videoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoList {
  int? id;
  String? title;
  String? category;
  int? categoryId;
  String? image;
  String? contentBy;
  String? url;
  String? video;
  String? subTitle;
  String? shortVideo;
  String? description;
  String? topics;
  String? duration;

  VideoList(
      {this.id,
        this.title,
        this.category,
        this.categoryId,
        this.image,
        this.contentBy,
        this.url,
        this.video,
        this.subTitle,
        this.shortVideo,
        this.description,
        this.topics,
        this.duration});

  VideoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    category = json['category'];
    categoryId = json['category_id'];
    image = json['image'];
    contentBy = json['content_by'];
    url = json['url'];
    video = json['video'];
    subTitle = json['sub_title'];
    shortVideo = json['short_video'];
    description = json['description'];
    topics = json['topics'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['category'] = this.category;
    data['category_id'] = this.categoryId;
    data['image'] = this.image;
    data['content_by'] = this.contentBy;
    data['url'] = this.url;
    data['video'] = this.video;
    data['sub_title'] = this.subTitle;
    data['short_video'] = this.shortVideo;
    data['description'] = this.description;
    data['topics'] = this.topics;
    data['duration'] = this.duration;
    return data;
  }
}
