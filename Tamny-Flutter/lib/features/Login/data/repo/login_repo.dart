

import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../model/usermodel.dart';
abstract class LoginRepo {

  Future<Either<Failure , UserModel>> login({required String  email , required String pass} ) ;

}