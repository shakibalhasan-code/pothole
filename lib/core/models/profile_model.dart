class ProfileModel {
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? role;
  String? image;
  Null? fcmToken;
  String? status;
  bool? verified;
  String? passwordChangedAt;
  Null? dateOfBirth;
  String? createdAt;
  String? updatedAt;
  String? fullName;

  ProfileModel({
    this.sId,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.role,
    this.image,
    this.fcmToken,
    this.status,
    this.verified,
    this.passwordChangedAt,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.fullName,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    image = json['image'];
    fcmToken = json['fcmToken'];
    status = json['status'];
    verified = json['verified'];
    passwordChangedAt = json['passwordChangedAt'];
    dateOfBirth = json['dateOfBirth'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    data['image'] = this.image;
    data['fcmToken'] = this.fcmToken;
    data['status'] = this.status;
    data['verified'] = this.verified;
    data['passwordChangedAt'] = this.passwordChangedAt;
    data['dateOfBirth'] = this.dateOfBirth;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['fullName'] = this.fullName;
    return data;
  }
}
