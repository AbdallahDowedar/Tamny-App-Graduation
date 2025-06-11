import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/doctors-repo-implementation.dart';
import 'doctors_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final DoctorsRepoImplementation repo;

  DoctorCubit(this.repo) : super(DoctorInitial());

  Future<void> getDoctors() async {
    emit(DoctorLoading());

    final result = await repo.GetDoctors();

    result.fold(
          (failure) => emit(DoctorError(failure.message)),
          (doctors) => emit(DoctorLoaded(doctors)),
    );
  }

  Future<void> approveDoctor(String docId) async {
    try {
      await repo.approveDoctor(docId);
      getDoctors();
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  Future<void> rejectDoctor(String docId) async {
    try {
      await repo.rejectDoctor(docId);
      getDoctors();
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}
