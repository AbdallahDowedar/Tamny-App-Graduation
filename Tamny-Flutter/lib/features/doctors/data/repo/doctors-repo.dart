
import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../Login/data/model/usermodel.dart';
import '../model/doctors-model.dart';

abstract class DoctorsRepo {

  Future<Either<Failure , List<Doctor_model>>> GetDoctors() ;
  Future<void> approveDoctor(String docId);
  Future<void> rejectDoctor(String docId);
}