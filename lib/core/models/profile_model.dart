class ProfileModel {
  String? nickname;
  String? dateOfBirth;
  String? phone;
  String? address;
  String? image;
  String? sId;
  String? fullName;
  String? email;
  User? user;
  String? profession;
  int? iV;

  ProfileModel({
    this.nickname,
    this.dateOfBirth,
    this.phone,
    this.address,
    this.image,
    this.sId,
    this.fullName,
    this.email,
    this.user,
    this.profession,
    this.iV,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'] ?? 'empty';
    dateOfBirth = json['dateOfBirth'] ?? 'empty';
    phone = json['phone'] ?? 'empty';
    address = json['address'] ?? 'empty';
    image =
        json['image'] ??
        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/800px-Placeholder_view_vector.svg.png';
    sId = json['_id'] ?? 'empty';
    fullName = json['fullName'] ?? 'empty';
    email = json['email'] ?? 'empty';
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    profession = json['profession'] ?? 'empty';
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['dateOfBirth'] = this.dateOfBirth;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['image'] = this.image;
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['profession'] = this.profession;
    data['__v'] = this.iV;
    return data;
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {};
    if (fullName != null) data['fullName'] = fullName;
    if (nickname != null) data['nickname'] = nickname;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    // Don’t include image, _id, profession, user, etc.
    return data;
  }
}

class User {
  Authentication? authentication;
  String? sId;
  String? email;
  String? role;
  bool? isVerified;
  bool? needToResetPass;
  bool? hasPremiumAccess;
  int? iV;

  User({
    this.authentication,
    this.sId,
    this.email,
    this.role,
    this.isVerified,
    this.needToResetPass,
    this.hasPremiumAccess,
    this.iV,
  });

  User.fromJson(Map<String, dynamic> json) {
    authentication =
        json['authentication'] != null
            ? new Authentication.fromJson(json['authentication'])
            : null;
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
    isVerified = json['isVerified'];
    needToResetPass = json['needToResetPass'];
    hasPremiumAccess = json['hasPremiumAccess'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.authentication != null) {
      data['authentication'] = this.authentication!.toJson();
    }
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['role'] = this.role;
    data['isVerified'] = this.isVerified;
    data['needToResetPass'] = this.needToResetPass;
    data['hasPremiumAccess'] = this.hasPremiumAccess;
    data['__v'] = this.iV;
    return data;
  }
}

class Authentication {
  String? expDate;
  String? otp;
  String? token;

  Authentication({this.expDate, this.otp, this.token});

  Authentication.fromJson(Map<String, dynamic> json) {
    expDate = json['expDate'];
    otp = json['otp'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expDate'] = this.expDate;
    data['otp'] = this.otp;
    data['token'] = this.token;
    return data;
  }
}
