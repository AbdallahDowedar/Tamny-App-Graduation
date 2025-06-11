import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/Routes/app_routes.dart';
import '../../core/utils/app_images.dart';
import '../Login/presentation/view/login_screen.dart';
import '../Login/presentation/view/widgets/custom_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  void initState() {

    super.initState();
    Future.delayed(const Duration(
        seconds: 2
    ) , () {

      Navigator.pushReplacementNamed(context,AppRoutes.loginpage);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(



body: Center(

  child: ZoomIn(
    child:CustomLogo()
  ),
),



    );
  }
}
