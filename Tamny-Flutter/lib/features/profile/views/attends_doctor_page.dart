import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/background_image/custom_background.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_texts.dart';
import '../controller/booking_cubit.dart';

class BookingRepo {
  Future<List<Booking>> getDoctorBookings(String doctorId) async {
    final response = await http.get(Uri.parse('${AppTexts.baseurl}/booking/doctor/$doctorId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final bookings = (data['bookings'] as List)
          .map((json) => Booking.fromJson(json))
          .toList();
      return bookings;
    } else {
      throw Exception('Failed to load bookings');
    }
  }


  Future<void> respondToBooking({
    required String bookingId,
    required String doctorId,
    required bool accept,
  }) async {
    final url = Uri.parse('${AppTexts.baseurl}/booking/respond');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'bookingId': bookingId,
        'doctorId': doctorId,
        'accept': accept,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to respond to booking');
    }
  }


}


class BookingPage extends StatelessWidget {
  final String doctorId;

  const BookingPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(BookingRepo())..fetchBookings(doctorId),
      child: Scaffold(

        body: CustomBackground(
          child: Column(
            children: [
              const SizedBox(height: 172),

              Expanded(
                child: BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    if (state is BookingLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BookingLoaded) {
                      final bookings = state.bookings;
                      if (bookings.isEmpty) {
                        return const Center(
                          child: Text(
                            "No bookings yet.",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: ListView.builder(
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            final schedule = booking.schedule;
                            final slot = schedule?.slots.firstWhere(
                                  (s) => s.id == booking.slotId,
                              orElse: () => Slot(
                                id: '',
                                startTime: 'N/A',
                                endTime: 'N/A',
                                isBooked: false,
                                status: 'unknown',
                              ),
                            );

                            return Card(
                              color: Colors.white.withOpacity(0.05),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.button.withOpacity(0.8),
                                  child: Text(
                                    booking.patient?.userName?.substring(0, 1).toUpperCase() ?? '?',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking.patient?.userName ?? 'Unknown Patient',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Date: ${schedule?.date ?? "N/A"}",
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      "Time: ${slot?.startTime ?? ""} - ${slot?.endTime ?? ""}",
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      "Created At: ${booking.createdAt.toLocal().toString().split('.')[0]}",
                                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context.read<BookingCubit>().respondToBooking(
                                            bookingId: booking.id,
                                            doctorId: doctorId,
                                            accept: true,
                                          );
                                        },
                                        icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context.read<BookingCubit>().respondToBooking(
                                            bookingId: booking.id,
                                            doctorId: doctorId,
                                            accept: false,
                                          );
                                        },
                                        icon: const Icon(Icons.cancel, color: Colors.red),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is BookingError) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),




      ),
    );
  }
}
class Booking {
  final String id;
  final Patient? patient;
  final String doctorId;
  final Schedule? schedule;
  final String slotId;
  final String status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.patient,
    required this.doctorId,
    required this.schedule,
    required this.slotId,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      patient: json['patientId'] != null ? Patient.fromJson(json['patientId']) : null,
      doctorId: json['doctorId'],
      schedule: json['scheduleId'] != null ? Schedule.fromJson(json['scheduleId']) : null,
      slotId: json['slotId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Patient {
  final String id;
  final String userName;
  final String email;

  Patient({
    required this.id,
    required this.userName,
    required this.email,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      userName: json['userName'],
      email: json['email'],
    );
  }
}


class Schedule {
  final String id;
  final String doctorId;
  final String day;
  final String date;
  final List<Slot> slots;

  Schedule({
    required this.id,
    required this.doctorId,
    required this.day,
    required this.date,
    required this.slots,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    var slotList = (json['slots'] as List)
        .map((slot) => Slot.fromJson(slot))
        .toList();
    return Schedule(
      id: json['_id'],
      doctorId: json['doctorId'],
      day: json['day'],
      date: json['date'],
      slots: slotList,
    );
  }
}

class Slot {
  final String id;
  final String startTime;
  final String endTime;
  final bool isBooked;
  final String status;

  Slot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.status,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['_id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isBooked: json['isBooked'],
      status: json['status'],
    );
  }
}
