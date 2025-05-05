class ProfileModel {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  String? role;
  String? image;
  String? status;
  bool? verified;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;

  ProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.role,
    this.image,
    this.status,
    this.verified,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
      image: json['image'],
      status: json['status'],
      verified: json['verified'],
      dateOfBirth: json['dateOfBirth'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'role': role,
      'image': image,
      'status': status,
      'verified': verified,
      'dateOfBirth': dateOfBirth,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}