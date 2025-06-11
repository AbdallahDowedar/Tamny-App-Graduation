import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:doctor/core/errors/failure.dart';
import 'package:doctor/features/doctors/data/model/doctors-model.dart';
import 'package:doctor/features/doctors/data/repo/doctors-repo.dart';
import 'package:http/http.dart' as http;

import '../../../../core/utils/app_texts.dart';

class DoctorsRepoImplementation implements DoctorsRepo {
  @override
  Future<Either<Failure, List<Doctor_model>>> GetDoctors() async {
    try {
      final response = await http.get(Uri.parse("${AppTexts.baseurl}/admin/"));

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        final doctors = body.map((item) => Doctor_model.fromJson(item)).toList();
        return right(doctors.cast<Doctor_model>());
      } else {
        return left(ApiFailure(message: "Failed to load doctors"));
      }
    } catch (e) {
      print('Error occurred: $e');
      return left(ApiFailure(message: "Error Occurred"));
    }
  }

  @override
  Future<void> approveDoctor(String docId) async {
    final url = Uri.parse('${AppTexts.baseurl}/admin/approveDoctor/$docId');

    try {
      final response = await http.patch(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['response']['message'];
        print('Success: $message');
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Future<void> rejectDoctor(String docId) async {
    final url = Uri.parse('${AppTexts.baseurl}/admin/rejectDoctor/$docId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['response']['message'];
        print('Success: $message');
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
