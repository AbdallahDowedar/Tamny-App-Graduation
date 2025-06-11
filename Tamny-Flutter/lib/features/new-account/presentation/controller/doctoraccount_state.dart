part of 'doctoraccount_cubit.dart';

@immutable
sealed class DoctoraccountState {}

final class DoctoraccountInitial extends DoctoraccountState {}


class GreateAccountDocLoadingState extends DoctoraccountState{ }
class GreateAccountDocSuccessState extends DoctoraccountState {
  final DoctorLoginModel doctorLoginModel;

  GreateAccountDocSuccessState({required this.doctorLoginModel});
}

class GreateAccountDocphotoSuccess extends DoctoraccountState{}
class GreateAccountDocfinish extends DoctoraccountState{}
class GreateAccountDocFailureState extends DoctoraccountState{
  final String errorMessage;GreateAccountDocFailureState({required this.errorMessage});
}

