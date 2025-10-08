class MyTrainingModel {
  bool? status;
  List<Video>? video;

  MyTrainingModel({this.status, this.video});

  MyTrainingModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? title;
  String? contentBy;
  String? category;
  int? categoryId;
  int? videoId;
  String? subTitle;
  String? video;
  String? description;
  String? url;
  String? image;
  String? status;
  List<VideoSubtitle>? videoSubtitle;

  Video(
      {this.id,
        this.title,
        this.contentBy,
        this.category,
        this.categoryId,
        this.videoId,
        this.subTitle,
        this.video,
        this.description,
        this.url,
        this.image,
        this.status,
        this.videoSubtitle});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    contentBy = json['content_by'];
    category = json['category'];
    categoryId = json['category_id'];
    videoId = json['video_id'];
    subTitle = json['sub_title'];
    video = json['video'];
    description = json['description'];
    url = json['url'];
    image = json['image'];
    status = json['status'];
    if (json['video_subtitle'] != null) {
      videoSubtitle = <VideoSubtitle>[];
      json['video_subtitle'].forEach((v) {
        videoSubtitle!.add(new VideoSubtitle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content_by'] = this.contentBy;
    data['category'] = this.category;
    data['category_id'] = this.categoryId;
    data['video_id'] = this.videoId;
    data['sub_title'] = this.subTitle;
    data['video'] = this.video;
    data['description'] = this.description;
    data['url'] = this.url;
    data['image'] = this.image;
    data['status'] = this.status;
    if (this.videoSubtitle != null) {
      data['video_subtitle'] =
          this.videoSubtitle!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoSubtitle {
  int? id;
  String? filePath;
  String? audioType;

  VideoSubtitle({this.id, this.filePath, this.audioType});

  VideoSubtitle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filePath = json['file_path'];
    audioType = json['audio_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_path'] = this.filePath;
    data['audio_type'] = this.audioType;
    return data;
  }
}
