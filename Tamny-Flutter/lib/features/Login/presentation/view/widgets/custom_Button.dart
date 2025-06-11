import 'package:doctor/core/utils/app_colors.dart';
import 'package:doctor/core/utils/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.txt});
  final VoidCallback onPressed;
final String txt;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: 210.w,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AppColors.button,
        ),
        child: Text(
          txt,
          style: GoogleFonts.almarai(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


class CustomButton2 extends StatelessWidget {
  const CustomButton2({super.key, required this.onPressed, required this.txt});
  final VoidCallback onPressed;
final String txt;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: 210.w,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AppColors.button,
        ),
        child: Text(
          txt,
          style: GoogleFonts.almarai(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
