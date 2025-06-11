import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_texts.dart';

class CustomRowField extends StatelessWidget {
  const CustomRowField({super.key, required this.txt, this.controller, this.keyboardType, this.obscureText});
  final String txt;
  final TextInputType? keyboardType;
  final bool? obscureText;
final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [

         SizedBox(width: 5.r,),

          SizedBox(
            width: 70.w,
            child: Text(
              txt,
              style: GoogleFonts.almarai(
                color: AppColors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),

          SizedBox(
            width: 210.w,
            child: TextFormField(
              obscureText: obscureText ?? false,
              keyboardType: keyboardType,
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),




        ],
      ),
    );
  }
}

