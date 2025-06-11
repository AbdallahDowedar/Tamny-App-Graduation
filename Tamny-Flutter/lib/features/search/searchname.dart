import 'package:doctor/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../../core/background_image/custom_background.dart';
import 'avilaible_slots_screen.dart';
import 'custom-txt-field.dart';
import 'model/doc_model.dart';

class DoctorsPage2 extends StatefulWidget {
  const DoctorsPage2({Key? key}) : super(key: key);

  @override
  State<DoctorsPage2> createState() => _DoctorsPage2State();
}

class _DoctorsPage2State extends State<DoctorsPage2> {
  late Future<DoctorResponse2> futureDoctors;
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'None';

  @override
  void initState() {
    super.initState();
    futureDoctors = getDoctorsByName(name: 'ا');
  }

  void searchDoctorsByName() {
    setState(() {
      futureDoctors = getDoctorsByName(name: searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: CustomBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 200),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Text(
                  'Find Your Doctor',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextformfeild(
                controller: searchController,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: searchDoctorsByName,
                ),
                hintText: 'Enter doctor name',
                keyboardType: TextInputType.name,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: DropdownButton<String>(
                value: selectedFilter,
                dropdownColor: AppColors.button,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.white,
                items: <String>[
                  'None',
                  'By Fees',
                  'Rate: High to Low',
                  'Rate: Low to High'
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
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<DoctorResponse2>(
                future: futureDoctors,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    return const Center(
                      child: Text(
                        'No doctors found.',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    );
                  }

                  final doctors = snapshot.data!.data;

                  if (selectedFilter == 'By Fees') {
                    doctors.sort((a, b) =>
                        b.consultationFees.compareTo(a.consultationFees));
                  } else if (selectedFilter == 'Rate: High to Low') {
                    doctors.sort((a, b) => b.rate.compareTo(a.rate));
                  } else if (selectedFilter == 'Rate: Low to High') {
                    doctors.sort((a, b) => a.rate.compareTo(b.rate));
                  }

                  return ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      print(doctor.userName);
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
                                child: Icon(Icons.person,
                                    color: AppColors.button, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor.userName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Specialization: ${doctor.specialization}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Consultation Fees: ${doctor.consultationFees}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rate: ${doctor.rate}',
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
                                  backgroundColor: AppColors.button,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingSlotsPage(
                                        locations: doctor.locations,
                                        rate: doctor.rate.toInt(),
                                        price: doctor.consultationFees ?? 0,
                                        doctorId: doctor.id.toString(),
                                        doctorName: doctor.userName,
                                        doctorDescription:
                                        doctor.specialization,
                                        phone: doctor.phone,
                                        description: doctor.description,

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
