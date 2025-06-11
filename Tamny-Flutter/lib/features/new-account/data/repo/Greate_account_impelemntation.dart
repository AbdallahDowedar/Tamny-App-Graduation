import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/app_texts.dart';
import '../model/new_account_model.dart';
import 'Greate_account_repo.dart';

class GreateAccountImplementation implements GreateAccountRepo {
  @override
  Future<Either<Failure, UserModelToRegister>> Greate_account_Sick({
    required UserModelToRegister userModelToRegister,
  }) async {
    try {
      final uri = Uri.parse("${AppTexts.baseurl}/auth/register");

      final response = await http.post(
        uri,
        body: jsonEncode(userModelToRegister.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);

        final String? token = body["token"];
        final String? msg = body["msg"];

        if (msg == "done" && token != null) {
          print("Token: $token");
          return right(userModelToRegister);
        } else {
          return left(ApiFailure(message: body["msg"] ?? "Registration failed"));
        }
      }
          else {
        return left(ApiFailure(message: "Server error: ${response.statusCode}"));
      }
    } on SocketException {
      return left(NoInternetFailure(message: "No Internet connection"));
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }



  Future<Either<Failure, DoctorLoginModel>> Greate_account_Doctor({
    required DoctorLoginModel doctorLoginModel,
  }) async {
    try {
      final uri = Uri.parse("${AppTexts.baseurl}/doctor/register_doctor");

      final response = await http.post(
        uri,
        body: doctorLoginModel.toJson(),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final doctor = DoctorLoginModel.fromMap(body);
        return right(doctor);
      } else {
        return left(ApiFailure(message: body["message"] ?? "Registration failed"));
      }
    } on SocketException {
      return left(NoInternetFailure(message: "No Internet connection"));
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

}
