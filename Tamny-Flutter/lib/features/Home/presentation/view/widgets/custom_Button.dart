import 'package:doctor/core/utils/app_colors.dart';
import 'package:doctor/core/utils/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonBook extends StatelessWidget {
  const CustomButtonBook({super.key, this.onTap});
 final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: 120.w,
        decoration: BoxDecoration(
           color: Colors.red,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(child: Text(AppTexts.search,style: TextStyle(
          fontSize: 25,color: AppColors.white
        ),)),
      ),
    );
  }
}
