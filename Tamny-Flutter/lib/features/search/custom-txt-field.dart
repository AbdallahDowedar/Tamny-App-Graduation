import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/app_colors.dart';

class CustomTextformfeild extends StatelessWidget {
  const CustomTextformfeild({
    super.key,
    required this.keyboardType,
    required this.suffixIcon,
    required this.controller,
    this.hintText,
  });

  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        autofocus: false,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: GoogleFonts.almarai(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.white,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.white,
              width: 2.0,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(left: isRTL ? 15 : 0, right: isRTL ? 0 : 15),
            child: suffixIcon,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.almarai(
            color: AppColors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}