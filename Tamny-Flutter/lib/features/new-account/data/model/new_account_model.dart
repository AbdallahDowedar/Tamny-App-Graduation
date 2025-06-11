

import 'dart:convert';

class UserModelToRegister {
  final String username;
  final String email;
  final String password;
  final String cpassword;

  UserModelToRegister({
    required this.username,
    required this.email,
    required this.password,
    required this.cpassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "userName": username,
      "email": email,
      "password": password,
      "Cpassword": cpassword,
    };
  }
}






class DoctorLoginModel {
  final String userName;
  final String email;
  final String password;
  final String role;
  final String locations;
  final String city;
  final int consultationFees;
  final String specialization;
  final int rate;
  final String phone;
  final String description;
  final String area;
  final String nickName;

  DoctorLoginModel({
    required this.userName,
    required this.email,
    required this.password,
    this.role = "doctor",
    required this.locations,
    required this.city,
    required this.consultationFees,
    required this.specialization,
    required this.rate,
    required this.phone,
    required this.description,
    required this.area,
    required this.nickName,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'role': role,
      'locations': locations,
      'city': city,
      'consultationFees': consultationFees,
      'specialization': specialization,
      'rate': rate,
      'phone': phone,
      'description': description,
      'area': area,
      'nickName': nickName,
    };
  }

  factory DoctorLoginModel.fromMap(Map<String, dynamic> map) {
    return DoctorLoginModel(
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'doctor',
      locations: map['locations'] ?? '',
      city: map['city'] ?? '',
      consultationFees: map['consultationFees'] ?? 0,
      specialization: map['specialization'] ?? '',
      rate: map['rate'] ?? 0,
      phone: map['phone'] ?? '',
      description: map['description'] ?? '',
      area: map['area'] ?? '',
      nickName: map['nickName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorLoginModel.fromJson(String source) =>
      DoctorLoginModel.fromMap(json.decode(source));
}


