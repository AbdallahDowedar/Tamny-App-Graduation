import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';

class CustomRowField_time extends StatefulWidget {

 CustomRowField_time({super.key, required this.txt, this.controller});
  final String txt;
 final TextEditingController? controller;

  @override
  State<CustomRowField_time> createState() => _CustomRowField_timeState();
}

class _CustomRowField_timeState extends State<CustomRowField_time> {

  @override
  Widget build(BuildContext context) {



    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [

          SizedBox(width: 5.r,),

          SizedBox(
            width: 50.w,
            child: Text(
              widget.txt,
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
            width: 115.w,
            height: 50.h,
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: OutlineInputBorder(
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
