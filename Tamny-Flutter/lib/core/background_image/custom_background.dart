

import 'package:doctor/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key, this.child});
final Widget? child;
  @override
  Widget build(BuildContext context) {
    return  Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          
          image: DecorationImage(
            image: AssetImage(AppImages.back_ground),
            fit: BoxFit.cover,
          ),
        ),
        child:child
    );
  }
}



class CustomBackground2 extends StatelessWidget {
  const CustomBackground2({super.key, this.child});
final Widget? child;
  @override
  Widget build(BuildContext context) {
    return  Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(

          image: DecorationImage(
            image: AssetImage(AppImages.back_ground2),
            fit: BoxFit.cover,
          ),
        ),
        child:child
    );
  }
}

class CustomBackground3 extends StatelessWidget {
  const CustomBackground3({super.key, this.child});
final Widget? child;
  @override
  Widget build(BuildContext context) {
    return  Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(

          image: DecorationImage(
            image: AssetImage(AppImages.back_ground3),
            fit: BoxFit.cover,
          ),
        ),
        child:child
    );
  }
}
