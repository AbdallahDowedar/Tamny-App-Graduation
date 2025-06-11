import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/background_image/custom_background.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../search/avilaible_slots_screen.dart';

class SearchArea extends StatefulWidget {
  const SearchArea({super.key});

  @override
  State<SearchArea> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  final TextEditingController _areaController = TextEditingController();
  List<dynamic> doctors = [];
  bool isLoading = false;
  String selectedFilter = 'None';

  Future<void> searchDoctors(String area) async {
    setState(() {
      isLoading = true;
      doctors = [];
    });

    try {
      final response = await http.get(
        Uri.parse('${AppTexts.baseurl}/doctor/area?area=$area'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success']) {
          setState(() {
            doctors = jsonData['data'];
            applyFilter();
          });
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void applyFilter() {
    if (selectedFilter == 'By Fees') {
      doctors.sort((a, b) => (b['consultationFees'] ?? 0).compareTo(a['consultationFees'] ?? 0));
    } else if (selectedFilter == 'By Rate') {
      doctors.sort((a, b) => (b['rate'] ?? 0).compareTo(a['rate'] ?? 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(
                'Find Doctors by Area',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 20),

              // Search bar
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _areaController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter area name...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          final area = _areaController.text.trim();
                          if (area.isNotEmpty) {
                            searchDoctors(area);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButton<String>(
                    value: selectedFilter,
                    dropdownColor: AppColors.button,
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    items: <String>['None', 'price', 'rate']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedFilter = newValue;
                          applyFilter(); // Apply filter again on change
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : doctors.isEmpty
                    ? const Center(
                  child: Text(
                    'No doctors found.',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];

                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey[100],
                              child: const Icon(Icons.person, color: Colors.blueAccent, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor['userName'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Specialization: ${doctor['specialization'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Area: ${doctor['area'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Fees: ${doctor['consultationFees'] ?? 0} EGP',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rate: ${doctor['rate'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>BookingSlotsPage(
                                      rate: doctor['rate'] ?? 0,
                                      doctorId: doctor['id'].toString(),
                                      doctorName: doctor['userName'] ?? '',
                                      doctorDescription: doctor['specialization'] ?? '',
                                      price: doctor['consultationFees'] ?? 0,
                                      locations: (doctor['locations'] as List<dynamic>?)?.first.toString() ?? '',
                                      phone: doctor['phone'] ?? '',
                                      description: doctor['description'] ?? '',

                                    ),

                                  ),
                                );
                              },
                              child: const Text(
                                "Book",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
