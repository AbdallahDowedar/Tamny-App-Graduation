import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/utils/app_texts.dart';

class SpecializationModel {
  final String id;
  final String name;

  SpecializationModel({required this.id, required this.name});

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['_id'],
      name: json['name'],
    );
  }
}


Future<List<SpecializationModel>> fetchSpecializations() async {
  final response = await http.get(Uri.parse('${AppTexts.baseurl}/specialization/'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['data'];
    return data.map((json) => SpecializationModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load specializations');
  }
}
