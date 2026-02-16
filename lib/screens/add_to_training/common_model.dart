class CommonModel {
  bool? status;
  String? message;
  String? verifyToken;

  CommonModel({this.status, this.message,this.verifyToken});

  CommonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    verifyToken = json['verify_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['verify_token'] = this.verifyToken;
    return data;
  }
}
