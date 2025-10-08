class UserModel {
  String? status;
  int? statusCode;
  String? message;
  List<User>? user;
  String? tokenType;
  String? token;
  Errors? errors;

  UserModel(
      {this.status,
        this.statusCode,
        this.message,
        this.user,
        this.tokenType,
        this.token,this.errors});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    errors =
    json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    message = json['message'];
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
    tokenType = json['token_type'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    if (this.errors != null) {
      data['errors'] = this.errors!.toJson();
    }
    data['token_type'] = this.tokenType;
    data['token'] = this.token;
    return data;
  }
}

class User {
  int? id;
  String? userType;
  String? firstName;
  String? lastName;
  String? birthday;
  String? gender;
  String? email;
  Null? tempPassword;
  String? address;
  String? number;
  String? city;
  String? zIP;
  String? profilePhoto;
  String? coverPhoto;
  Null? emailVerifiedAt;
  String? resetToken;
  int? companyVerified;
  int? sendLoginDetails;
  int? companyEnable;
  String? createdAt;
  String? updatedAt;
  Null? companyName;
  Null? seafarerNumber;
  Null? rank;
  String? nationality;
  String? role;
  String? vesselName;
  Null? position;
  Null? country;

  User(
      {this.id,
        this.userType,
        this.firstName,
        this.lastName,
        this.birthday,
        this.gender,
        this.email,
        this.tempPassword,
        this.address,
        this.number,
        this.city,
        this.zIP,
        this.profilePhoto,
        this.coverPhoto,
        this.emailVerifiedAt,
        this.resetToken,
        this.companyVerified,
        this.sendLoginDetails,
        this.companyEnable,
        this.createdAt,
        this.updatedAt,
        this.companyName,
        this.seafarerNumber,
        this.rank,
        this.nationality,
        this.role,
        this.vesselName,
        this.position,
        this.country});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['userType'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    birthday = json['birthday'];
    gender = json['gender'];
    email = json['email'];
    tempPassword = json['tempPassword'];
    address = json['address'];
    number = json['number'];
    city = json['city'];
    zIP = json['ZIP'];
    profilePhoto = json['profile_photo'];
    coverPhoto = json['cover_photo'];
    emailVerifiedAt = json['email_verified_at'];
    resetToken = json['reset_token'];
    companyVerified = json['company_verified'];
    sendLoginDetails = json['sendLoginDetails'];
    companyEnable = json['company_enable'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyName = json['company_name'];
    seafarerNumber = json['seafarer_number'];
    rank = json['rank'];
    nationality = json['nationality'];
    role = json['role'];
    vesselName = json['vesselName'];
    position = json['position'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userType'] = this.userType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['tempPassword'] = this.tempPassword;
    data['address'] = this.address;
    data['number'] = this.number;
    data['city'] = this.city;
    data['ZIP'] = this.zIP;
    data['profile_photo'] = this.profilePhoto;
    data['cover_photo'] = this.coverPhoto;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['reset_token'] = this.resetToken;
    data['company_verified'] = this.companyVerified;
    data['sendLoginDetails'] = this.sendLoginDetails;
    data['company_enable'] = this.companyEnable;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['company_name'] = this.companyName;
    data['seafarer_number'] = this.seafarerNumber;
    data['rank'] = this.rank;
    data['nationality'] = this.nationality;
    data['role'] = this.role;
    data['vesselName'] = this.vesselName;
    data['position'] = this.position;
    data['country'] = this.country;
    return data;
  }
}

class Errors {
  List<String>? email;

  Errors({this.email});

  Errors.fromJson(Map<String, dynamic> json) {
    email = json['email'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}
