import 'package:doctor/features/Home/presentation/view/search_area.dart';
import 'package:doctor/features/Home/presentation/view/widgets/custom_Button.dart';
import 'package:doctor/features/Home/presentation/view/widgets/texts_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/background_image/custom_background.dart';
import 'package:doctor/core/Routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_texts.dart';
import '../../../ai/chat_page.dart';
import '../../../new-account/data/model/location_model.dart';
import '../../../new-account/data/model/spclazition_model.dart';
import '../../../search/search_page.dart';
import '../../../search/searchname.dart';
import '../agree_booking.dart';

class BookDoctor extends StatefulWidget {
  const BookDoctor({super.key});

  @override
  State<BookDoctor> createState() => _BookDoctorState();
}

class _BookDoctorState extends State<BookDoctor> {
  String? selectedSpecialty;
  bool isExpanded = false;
TextEditingController name=TextEditingController();
  List<String> specialties = [
    "امراض جهاز هضمي",
    "امراض غدد صماء",
    "امراض روماتيزم",
  ];
  List<LocationModel> locations = [];
  LocationModel? selectedLocation;
  List<SpecializationModel> specialization = [];
  SpecializationModel? selectedSpecialization;
  void initState() {
    super.initState();
    loadLocations();
    loadspec();
  }

  Future<void> loadLocations() async {
    try {
      final result = await fetchLocations();
      setState(() {
        locations = result;
      });
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  Future<void> loadspec() async {
    try {
      final result = await fetchSpecializations();
      setState(() {
        specialization = result;
      });
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AgreeBooking(),));
        }, icon: Icon(Icons.person_outline)),
      ),
      resizeToAvoidBottomInset: false,

      body: CustomBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),

              Text(
                "احجز دكتور",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              
              
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  DoctorsPage2(),));
                },
                child: Container(
                  height: 50,
                  width: 360,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("البحث بالاسم ",style:  GoogleFonts.almarai(
                        color: Colors.grey.withOpacity(0.7),
                        fontSize: 16,
                      ),),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 20.h),


              InkWell(

                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  SearchArea(),));
                },
                child: Container(
                  height: 50,
                  width: 360,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("البحث بالمنطقه ",style:  GoogleFonts.almarai(
                        color: Colors.grey.withOpacity(0.7),
                        fontSize: 16,
                      ),),
                    ],
                  ),
                ),
              ),



              SizedBox(height: 5.h),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(Icons.location_on, color: Colors.redAccent),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<LocationModel>(
                              isExpanded: true,
                              hint: Text(
                                'اختر الموقع',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.right,
                              ),
                              items: locations.map((loc) {
                                return DropdownMenuItem<LocationModel>(
                                  value: loc,
                                  child: Text(
                                    loc.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              }).toList(),
                              value: selectedLocation,
                              onChanged: (value) {
                                setState(() {
                                  selectedLocation = value;
                                });
                              },
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(Icons.location_on, color: Colors.redAccent),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<SpecializationModel>(
                              isExpanded: true,
                              hint: Text(
                                'اختر التخصص',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.right,
                              ),
                              items: specialization.map((spec) {
                                return DropdownMenuItem<SpecializationModel>(
                                  value: spec,
                                  child: Text(
                                    spec.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              }).toList(),
                              value: selectedSpecialization,
                              onChanged: (value) {
                                setState(() {
                                  selectedSpecialization = value;
                                });
                              },
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              CustomButtonBook(
                onTap: () {


                  if(name.text!=null){


                    if(  selectedSpecialization!.id != null && selectedLocation!.id != null){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorsPage(
                            specializationId:"${selectedSpecialization!.id}",
                            locationId:"${selectedLocation!.id}",
                          ),
                        ),
                      );


                      print(selectedSpecialization!.id);
                      print(selectedLocation!.id);
                    }
                  }






                  },
              ),

              SizedBox(height: 160.h),


              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child:CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 40.r,
                    child:  IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => ChatPage(),));
                    }, icon: Icon(Icons.chat,size: 50,color: Colors.red,)),

                  )
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}



