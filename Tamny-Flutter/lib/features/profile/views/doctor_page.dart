import 'package:doctor/core/background_image/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../core/utils/app_texts.dart';
import '../data/model/book_model.dart';
import '../profle_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<BookingModel>> fetchBookings(String doctorId) async {
  final url = Uri.parse('${AppTexts.baseurl}/booking/bookings/$doctorId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List list = data['data'];
    return list.map((json) => BookingModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load bookings');
  }
}

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("setting");
    String id = box.get("Iddoctor");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfleScreen()));
          },
          icon: const Icon(Icons.person),
        ),



      ),
      body: CustomBackground(
        child: Column(
          children: [


            SizedBox(height: MediaQuery.sizeOf(context).height*0.15 ),



            Expanded(
              child: FutureBuilder<List<BookingModel>>(
                future: fetchBookings(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No bookings found'));
                  } else {
                    final bookings = snapshot.data!;
                    return ListView.builder(
                      itemCount: bookings.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
              
                        return Card(
                          color: Colors.white.withOpacity(0.09),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blueAccent.withOpacity(0.8),
                              child: Text(
                                booking.patientName.isNotEmpty ? booking.patientName[0].toUpperCase() : '?',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.patientName,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  booking.patientEmail,
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Date: ${booking.day} - ${booking.date}",
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                                Text(
                                  "Time: ${booking.startTime} - ${booking.endTime}",
                                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              decoration: BoxDecoration(
                                color: booking.status == 'confirmed' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking.status,
                                style: TextStyle(
                                  color: booking.status == 'confirmed' ? Colors.greenAccent : Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
