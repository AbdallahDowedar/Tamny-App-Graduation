import 'package:another_flushbar/flushbar.dart';
import 'package:doctor/core/utils/app_colors.dart';
import 'package:doctor/core/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/background_image/custom_background.dart';

class BookingSlotsPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorDescription;
  final String locations;
  final String phone;
  final String description;

  final int rate;
  final int price;

  const BookingSlotsPage({
    Key? key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorDescription, required this.price, required this.locations, required this.rate, required this.phone, required this.description,
  }) : super(key: key);


  @override
  State<BookingSlotsPage> createState() => _BookingSlotsPageState();
}

class _BookingSlotsPageState extends State<BookingSlotsPage> {
  List<Schedule> schedules = [];
  bool isLoading = true;

  String? selectedScheduleId;
  String? selectedSlotId;

   double currentRating = 0;


  @override
  void initState() {
    super.initState();
    fetchSlots();
  }
  Future<void> rateDoctor() async {
    var box = Hive.box("setting");
    String token = box.get("token");

    final url = Uri.parse("${AppTexts.baseurl}/rate/${widget.doctorId}/$currentRating");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      Flushbar(
        message: "تم إرسال التقييم بنجاح",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: const Icon(Icons.star, color: Colors.white),
      ).show(context);
    } else {
      print("Error response: ${response.body}");
      Flushbar(
        message: "فشل إرسال التقييم",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
    }
  }

  Future<void> fetchSlots() async {
    final url = Uri.parse(
      "${AppTexts.baseurl}/booking/slots/${widget.doctorId}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<Schedule> loadedSchedules = (decoded['data'] as List)
          .map((item) => Schedule.fromJson(item))
          .toList();

      setState(() {
        schedules = loadedSchedules;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Failed to load slots. Status: ${response.statusCode}");
    }
  }
  Future<void> bookSlot({
    required String scheduleId,
    required String slotId,
    required String patientId,
  }) async {
    final url = Uri.parse("${AppTexts.baseurl}/booking/book");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "scheduleId": scheduleId,
        "slotId": slotId,
        "patientId": patientId,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      Flushbar(
        message: "طلبك قيد الانتظار",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green.shade600,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ).show(context);
    } else {
      Flushbar(
        message: "فشل الحجز",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade600,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
    }

  }


  Schedule? selectedSchedule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground2(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(height: 160.h),

              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:Colors.grey.shade200,
                      child:   Icon(Icons.person, color: AppColors.button, size: 60),

                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.doctorName,
                                style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 4),
                            Text("التخصص : ${widget.doctorDescription}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),

                            const SizedBox(height: 4),
                            Text("المنطقه : ${widget.locations}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                            const SizedBox(height: 4),
                            Text("السعر : ${widget.price} ج",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),        const SizedBox(height: 4),
                            Text("الوصف : ${widget.description} ",
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black,)),        const SizedBox(height: 4),
                            Text("الهاتف : ${widget.phone}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),



              const SizedBox(height: 10),
              Center(
                child: Text("المواعيد المتاحه ",
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : schedules.isEmpty
                  ? const Center(
                child: Text(
                  'No available schedules.',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 120,
                        width: 300,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = schedules[index];
                            final isSelected = selectedSchedule?.scheduleId == schedule.scheduleId;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSchedule = schedule;
                                  selectedScheduleId = schedule.scheduleId;
                                  selectedSlotId = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.indigo,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    schedule.day,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    if (selectedSchedule != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " available for this ${selectedSchedule!.day} :",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: selectedSchedule!.slots.map((slot) {
                                  final isSelected = selectedSlotId == slot.id;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSlotId = slot.id;
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.green.withOpacity(0.9)
                                            : Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: isSelected ? Colors.green : Colors.white30),
                                      ),
                                      child: Text(
                                        "${slot.startTime} - ${slot.endTime}",
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                        ],
                      ),
                  ],
                ),
              ),



              Align(
                alignment: Alignment.bottomRight,
                child: RatingBar.builder(
                  initialRating: currentRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      currentRating = rating  ;
                    });
                    print("Selected Rating: $currentRating");
                  },
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,

                child: GestureDetector(
                  onTap: () {

                    var box = Hive.box("setting");
                    String token = box.get("token");

                    print("DOcCCC: ${widget.doctorId}");
                    print("Selected Rating: $currentRating");
                    print("Selected Rating: $token");
                    if (currentRating > 0) {
                      rateDoctor();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("من فضلك اختر تقييم أولاً")),
                      );
                    }
                  },
                  child: Container(
                    width: 180,
                    height: 48,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        "قيّم الدكتور",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: GestureDetector(
                  onTap: () {
                    var box = Hive.box("setting");
                    String id = box.get("id");

                    if (selectedScheduleId != null && selectedSlotId != null) {
                      bookSlot(
                        scheduleId: selectedScheduleId!,
                        slotId: selectedSlotId!,
                        patientId: id,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a slot first")),
                      );





                    }
                  },
                  child: Container(
                    width: 180,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.button,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        "Book",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
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

class Schedule {
  final String scheduleId;
  final String day;
  final String date;
  final List<Slot> slots;

  Schedule({
    required this.scheduleId,
    required this.day,
    required this.date,
    required this.slots,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      day: json['day'],
      date: json['date'],
      slots: (json['slots'] as List)
          .map((slotJson) => Slot.fromJson(slotJson))
          .toList(),
    );
  }
}
