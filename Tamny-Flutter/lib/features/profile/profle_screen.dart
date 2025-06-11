import 'package:doctor/core/utils/app_colors.dart';
import 'package:doctor/features/profile/views/attends_doctor_page.dart';
import 'package:doctor/features/profile/views/update_times_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../core/background_image/custom_background.dart';
import '../../core/utils/app_texts.dart';
import '../Login/presentation/view/login_screen.dart';
import '../Login/presentation/view/widgets/custom_Button.dart';
class ProfleScreen extends StatelessWidget {
  const ProfleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: CustomBackground2(

        child:  Center(
          child:Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height*0.2,),

                Container(
                  height: 700.h,
                  width: 500.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    color: AppColors.white,

                  ),
                  child: Column(
                    children: [


                      SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),



                      Container(
                        height: 150.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 5),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/690-6904538_men-profile-icon-png-image-free-download-searchpng.webp",
                                  height: 130.h,
                                  width: 100.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              left:120,
                              child: IconButton(
                                onPressed: () {
                                },
                                icon: Icon(
                                  Icons.mode_edit_outline_outlined,
                                  color:AppColors.button,
                                  size: 60,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

                      Text(
                        "اسم الدكتور",
                        style: GoogleFonts.almarai(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),


                      SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

                      CustomButton2(
                        txt:AppTexts.newaccount_button,
                        onPressed: () {
                        },),

                      SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

                      CustomButton2(
                        txt:AppTexts.update,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SetScheduleInputPage()));
                        },),

                      SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),

                      CustomButton2(
                        txt:AppTexts.updatedeatils,
                        onPressed: () {
                          var box = Hive.box("setting");
                          String id = box.get("Iddoctor");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage(doctorId:id ,)));
                        },),


                      SizedBox(height: MediaQuery.sizeOf(context).height*0.09,),

                      CustomButton(
                        txt:AppTexts.logout,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        },),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ),


      ),
    );
  }
}

