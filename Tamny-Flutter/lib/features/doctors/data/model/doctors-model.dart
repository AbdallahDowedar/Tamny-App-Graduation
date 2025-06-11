class Doctor_model {
  final String id;
  final UserModel? user;
  final SpecializationModel? specialization;
  final bool isVerified;
  final LocationModel? locations;
  final String? description;
  final String? nickName;

  Doctor_model({
    required this.id,
    this.user,
    this.specialization,
    required this.isVerified,
    this.locations,
    this.description,
    this.nickName,
  });

  factory Doctor_model.fromJson(Map<String, dynamic> json) {
    return Doctor_model(
      id: json['_id'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      specialization: json['specialization'] != null
          ? SpecializationModel.fromJson(json['specialization'])
          : null,
      isVerified: json['isVerified'] ?? false,
      locations: json['locations'] != null
          ? LocationModel.fromJson(json['locations'])
          : null,
      description: json['description'],
      nickName: json['nickName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'specialization': specialization?.toJson(),
      'isVerified': isVerified,
      'locations': locations?.toJson(),
      'description': description,
      'nickName': nickName,
    };
  }
}

class UserModel {
  final String? userName;

  UserModel({this.userName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
    };
  }
}

class SpecializationModel {
  final String? name;

  SpecializationModel({this.name});

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class LocationModel {
  final String? name;

  LocationModel({this.name});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
