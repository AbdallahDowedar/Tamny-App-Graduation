
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../model/new_account_model.dart';

abstract class GreateAccountRepo {

  Future<Either<Failure , UserModelToRegister>> Greate_account_Sick(
      {required UserModelToRegister userModelToRegister}) ;


  Future<Either<Failure , DoctorLoginModel>> Greate_account_Doctor(
      {required DoctorLoginModel doctorLoginModel}) ;

}