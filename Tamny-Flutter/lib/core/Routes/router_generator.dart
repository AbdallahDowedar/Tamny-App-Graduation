import 'package:doctor/core/Routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/Home/presentation/view/book_doctor.dart';
import '../../features/Login/presentation/view/login_screen.dart';
import '../../features/Splash_screen/splash_screen.dart';
import '../../features/new-account/presentation/view/Registration_screen.dart';
import '../../features/profile/profle_screen.dart';
import '../../features/profile/views/doctor_page.dart';

class  RouterGenerator {




// static GoRouter mainRoutingInourApp= GoRouter(
//
//     routes: [
//      GoRoute(
//     name:AppRoutes.splash ,
//     path: AppRoutes.splash ,
//        builder: (context, state) => SplashScreen(),
//      ),     GoRoute(
//     name:AppRoutes.loginpage ,
//     path: AppRoutes.loginpage ,
//        builder: (context, state) => LoginScreen(),
//      ),     GoRoute(
//     name:AppRoutes.signup ,
//     path: AppRoutes.signup ,
//        builder: (context, state) => RegistrationScreen(),
//      ),
//
//
//      ]
//        );



  Route generateRoute(RouteSettings settting){
   final arg =settting.arguments;
    switch(settting.name){

      case AppRoutes.splash:
     return MaterialPageRoute(builder: (context) {
       return SplashScreen();
     },);


      case AppRoutes.signup:
     return MaterialPageRoute(builder: (context) {
       return RegistrationScreen();
     },);


          case AppRoutes.loginpage:
     return MaterialPageRoute(builder: (context) {
       return LoginScreen();
     },);

     case AppRoutes.BookDoctor:
     return MaterialPageRoute(builder: (context) {
       return BookDoctor();
     },);

     case AppRoutes.ProfleScreen:
     return MaterialPageRoute(builder: (context) {
       return ProfleScreen();
     },);

     case AppRoutes.profilepage:
     return MaterialPageRoute(builder: (context) {
       return DoctorPage();
     },);


      default:
        return MaterialPageRoute(builder: (context) => Scaffold(body:Center(child: Text("No page route"),) ,),);

   }

  }
}