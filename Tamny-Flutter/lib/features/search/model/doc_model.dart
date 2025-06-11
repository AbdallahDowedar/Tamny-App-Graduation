import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/utils/app_texts.dart';

class Doctor {
  final String id;
  final String userName;
  final String specialization;
  final String locations;
  final int consultationFees;
  final String phone;
  final String description;
  final double rate;

  Doctor( {required this.id, required this.userName,
    required this. specialization, required this.locations,
    required this.consultationFees, required this.rate,
    required this.phone, required this.description,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      userName: json['userName'],
      specialization: json['specialization'],
      locations: json['locations'],
      consultationFees: json['consultationFees'],
      rate: (json['rate'] as num).toDouble(),
      phone: json['phone'],
      description: json['description'],

    );
  }
}

class DoctorResponse2 {
  final bool success;
  final List<Doctor> data;

  DoctorResponse2({required this.success, required this.data});

  factory DoctorResponse2.fromJson(Map<String, dynamic> json) {
    return DoctorResponse2(
      success: json['success'],
      data: (json['data'] as List)
          .map((doctorJson) => Doctor.fromJson(doctorJson))
          .toList(),
    );
  }
}


Future<DoctorResponse2> getDoctorsByName({required String name}) async {
  final Uri url = Uri.parse('${AppTexts.baseurl}/doctor/search?name=${Uri.encodeQueryComponent(name)}');
  print('Calling URL: $url');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return DoctorResponse2.fromJson(data);
  } else {
    print('Response body: ${response.body}');
    throw Exception('Failed to load doctors: ${response.statusCode}');
  }
}

void fetchDoctorsName() async {
  try {
    final response = await getDoctorsByName(name: 'mostafa');
    if (response.success) {
      for (var doctor in response.data) {
        print('Doctor: ${doctor.userName}, ID: ${doctor.id}');
      }
    } else {
      print('No doctor ');
    }
  } catch (e) {
    print('Error: $e');
  }
}



