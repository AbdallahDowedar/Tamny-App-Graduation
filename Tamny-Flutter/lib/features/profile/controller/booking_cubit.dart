import 'package:flutter_bloc/flutter_bloc.dart';

import '../views/attends_doctor_page.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo repo;

  BookingCubit(this.repo) : super(BookingInitial());

  Future<void> fetchBookings(String doctorId) async {
    emit(BookingLoading());
    try {
      final bookings = await repo.getDoctorBookings(doctorId);
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }



  Future<void> respondToBooking({
    required String bookingId,
    required String doctorId,
    required bool accept,
  }) async {
    try {
      await repo.respondToBooking(
        bookingId: bookingId,
        doctorId: doctorId,
        accept: accept,
      );
      fetchBookings(doctorId);
    } catch (e) {
      emit(BookingError('Failed to respond: ${e.toString()}'));
    }
  }

}
