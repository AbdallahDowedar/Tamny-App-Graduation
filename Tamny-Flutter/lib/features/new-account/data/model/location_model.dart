import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/utils/app_texts.dart';

// نموذج بيانات الموقع
class LocationModel {
  final String id;
  final String name;

  LocationModel({required this.id, required this.name});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['_id'],
      name: json['name'],
    );
  }
}

// دالة لجلب المواقع من السيرفر
Future<List<LocationModel>> fetchLocations() async {
  final url = Uri.parse('${AppTexts.baseurl}/location/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    // تأكد من أن المفتاح 'data' موجود ويحتوي على قائمة
    if (data.containsKey('data') && data['data'] is List) {
      final List<dynamic> list = data['data'];
      return list.map((item) => LocationModel.fromJson(item)).toList();
    } else {
      throw Exception('Unexpected response structure');
    }
  } else {
    throw Exception('Failed to load locations: ${response.statusCode}');
  }
}
