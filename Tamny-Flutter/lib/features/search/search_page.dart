import 'package:flutter/material.dart';
import '../../core/background_image/custom_background.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_texts.dart';
import '../Home/data/model/search_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'avilaible_slots_screen.dart';


Future<DoctorResponse> getDoctors({
  required String specialization,
  required String location,
  double? minPrice,
  double? maxPrice,
  double? minRating,
}) async {
  final queryParameters = {
    'locations': location,
    'specialization': specialization,
  };

  if (minPrice != null) queryParameters['minPrice'] = minPrice.toString();
  if (maxPrice != null) queryParameters['maxPrice'] = maxPrice.toString();
  if (minRating != null) queryParameters['minRating'] = minRating.toString();

  final uri = Uri.parse('${AppTexts.baseurl}/doctor/filter/').replace(queryParameters: queryParameters);

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return DoctorResponse.fromJson(data);
  } else {
    throw Exception('Failed to load doctors: ${response.statusCode}');
  }
}


class DoctorsPage extends StatefulWidget {
  final String specializationId;
  final String locationId;

  const DoctorsPage({
    Key? key,
    required this.specializationId,
    required this.locationId,
  }) : super(key: key);

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  late Future<DoctorResponse> futureDoctors;

  String selectedFilter = 'None';

  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  void fetchDoctors() async {
    try {
      final result = await getDoctors(
        specialization: widget.specializationId,
        location: widget.locationId,
      );

      setState(() {
        allDoctors = result.doctors;
        filteredDoctors = List.from(allDoctors);
      });
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  void applyFilter() {
    List<Doctor> temp = List.from(allDoctors);

    if (selectedFilter == 'Fees: Low to High') {
      temp.sort((a, b) => a.consultationFees.compareTo(b.consultationFees));
    } else if (selectedFilter == 'Rating: High to Low') {
      temp.sort((a, b) => b.rate.compareTo(a.rate));
    } else {
      temp = List.from(allDoctors);
    }

    setState(() {
      filteredDoctors = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 140),
              const Text(
                'Our Doctors',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButton<String>(
                    value: selectedFilter,
                    dropdownColor: AppColors.button,
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    items: <String>[
                      'None',
                      'Fees: Low to High',
                      'Rating: High to Low',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedFilter = newValue;
                          applyFilter();
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: filteredDoctors.isEmpty
                    ? const Center(
                  child: Text(
                    'No doctors found.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctors[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingSlotsPage(
                              locations: doctor.locations,
                              rate: doctor.rate,
                              price: doctor.consultationFees,
                              doctorId: doctor.id,
                              doctorName: doctor.userName,
                              doctorDescription: "",
                              phone: doctor.phone,
                              description: doctor.description,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blueAccent,
                              child: const Icon(Icons.person, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.specialization,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Fees: \$${doctor.consultationFees}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rating: ${doctor.rate.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
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



