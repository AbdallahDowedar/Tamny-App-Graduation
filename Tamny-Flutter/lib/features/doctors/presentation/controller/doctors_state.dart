import 'package:doctor/features/doctors/data/model/doctors-model.dart';

abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorLoaded extends DoctorState {
  final List<Doctor_model> doctors;

  DoctorLoaded(this.doctors);
}

class DoctorError extends DoctorState {
  final String message;

  DoctorError(this.message);
}
