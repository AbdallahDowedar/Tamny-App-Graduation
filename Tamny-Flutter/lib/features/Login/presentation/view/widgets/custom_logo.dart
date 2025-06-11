import 'package:flutter/material.dart';

import '../../../../../core/utils/app_images.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Image(
        image: const AssetImage(AppImages.AppLogo),
        height:MediaQuery.sizeOf(context).height*0.3,
        width:MediaQuery.sizeOf(context).height*0.4 ,
      );

  }
}
