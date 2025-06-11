
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/app_texts.dart';
import '../model/usermodel.dart';
import 'login_repo.dart';

class LoginRepoImplementation implements LoginRepo {
  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String pass,
  }) async {try {
      final response = await http.post(
        Uri.parse("${AppTexts.baseurl}/auth/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": pass,
        }),
      );

      final responseBody = jsonDecode(response.body);
      print("Response: $responseBody");

      if (response.statusCode == 200 && responseBody["success"] == true) {
        final isVerified = responseBody["isVerified"];
        final role = responseBody["role"];
        final id = responseBody["id"];
        final iddoctor = responseBody["doctorId"]??"";
        final token = responseBody["token"];



        if (isVerified == false) {
          return left(ApiFailure(message: "Your account is not verified yet"));
        }

        return right(UserModel(email: email,
            password: pass,
            role: role,
            id: id,token: token,
            doctorid: iddoctor));
      }
      else {
        return left(ApiFailure(message: responseBody["message"] ?? "Login failed"));
      }
    } catch (e) {
      print("Error: $e");
      return left(ApiFailure(message: "Unexpected error occurred"));
    }
  }
}
