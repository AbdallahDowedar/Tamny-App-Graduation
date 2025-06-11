import 'dart:convert';
import 'package:doctor/core/background_image/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/app_texts.dart';

class BookingModel {
  final String id;
  final String day;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  BookingModel({
    required this.id,
    required this.day,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final slot = json['scheduleId']['slots'].first;
    return BookingModel(
      id: json['_id'],
      day: json['scheduleId']['day'],
      date: json['scheduleId']['date'],
      startTime: slot['startTime'],
      endTime: slot['endTime'],
      status: slot['status'],
    );
  }
}

Future<List<BookingModel>> fetchBookings(String patientId) async {
  final url = Uri.parse('${AppTexts.baseurl}/booking/userBookings/$patientId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final List data = jsonBody['data'];
    return data.map((e) => BookingModel.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load bookings');
  }
}

class AgreeBooking extends StatefulWidget {
  const AgreeBooking({super.key});

  @override
  State<AgreeBooking> createState() => _AgreeBookingState();
}

class _AgreeBookingState extends State<AgreeBooking> {
  late Future<List<BookingModel>> bookings;

  @override
  void initState() {
    super.initState();
    var box = Hive.box("setting");
    String patientId = box.get("id");
    bookings = fetchBookings(patientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: CustomBackground(

        child: Column(
          children: [


            SizedBox(height: MediaQuery.sizeOf(context).height*0.18 ),
            Expanded(
              child: FutureBuilder<List<BookingModel>>(
                future: bookings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No bookings found."));
                  }

                  final bookings = snapshot.data!;
                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,top:10 ),
                        child: Card(
                          child: ListTile(
                            leading: Icon(
                              booking.status == 'confirmed' ? Icons.check_circle : Icons.access_time,
                              color: booking.status == 'confirmed' ? Colors.green : Colors.orange,
                            ),
                            title: Text("Date: ${booking.date}"),
                            subtitle: Text(
                              "Day: ${booking.day}\nTime: ${booking.startTime} - ${booking.endTime}\nStatus: ${booking.status}",
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
