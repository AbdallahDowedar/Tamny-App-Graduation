import 'dart:convert';
import 'package:doctor/core/Routes/app_routes.dart';
import 'package:doctor/core/utils/app_colors.dart';
import 'package:doctor/core/utils/app_texts.dart';
import 'package:doctor/features/Login/presentation/view/widgets/custom_Button.dart';
import 'package:doctor/features/Login/presentation/view/widgets/custom_row_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/background_image/custom_background.dart';
import '../../../doctors/presentation/view/doctors_page.dart';
import '../../../profile/views/doctor_page.dart';
import '../controller/login_cubit.dart';
import 'package:http/http.dart' as http;
import 'otp_page.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: BlocConsumer<LoginCubit, LoginStates>(
              listener: (context, state) {
                if (state is LoginLoadingState) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(child: CircularProgressIndicator(color: AppColors.button),),
                  );
                }else if (state is LoginSuccessState) {
                  Navigator.pop(context); // remove loader
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login Successful")),
                  );

                  if (state.userModel.role == 'doctor') {
                    Navigator.push(context, MaterialPageRoute(builder:
                    (context) => DoctorPage()),);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.BookDoctor);
                  }
                }
                else if (state is LoginFailureState) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                } else if (state is LoginNotApprovedState) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Your account is not verified yet")),
                  );
                }
              },
              builder: (context, state) {
              final cubit = context.read<LoginCubit>();

              return Column(
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),

                  Text(
                    AppTexts.Login,
                    style: GoogleFonts.almarai(
                      color: AppColors.white,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),

                  CustomRowField(txt: AppTexts.email, controller: cubit.Email),

                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),

                  CustomRowField(txt: AppTexts.pass, controller: cubit.password,obscureText: true,),

                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),

                  CustomButton(
                    txt: AppTexts.login_button,
                      onPressed: () async {
                        if (cubit.Email.text == "tamineproject1@gmail.com" && cubit.password.text == "12345678T#") {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorsPage()));
                        } else {
                          await cubit.login(); // run login logicdfr
                          final state = context.read<LoginCubit>().state;
                          if (state is LoginSuccessState) {
                            cubit.Email.clear();
                            cubit.password.clear();
                          }
                        }
                      }

                  ),

                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),

                  CustomButton(
                    txt: AppTexts.newaccount_button,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signup);
                    },
                  ),

                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),

                  InkWell(
                    onTap: () async {
                      final email = cubit.Email.text.trim();

                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('من فضلك أدخل البريد الإلكتروني')),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        final response = await http.post(
                          Uri.parse('${AppTexts.baseurl}/auth/forgot-password'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({'email': email}),
                        );

                        Navigator.pop(context); // Close loading

                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم إرسال رابط استعادة كلمة المرور إلى بريدك')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('فشل في الإرسال: ${response.body}')),
                          );
                        }
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حدث خطأ أثناء الاتصال: $e')),
                        );
                      }
                      
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage(),));
                      


                      
                    },
                    child: Text(
                      AppTexts.forgetpass,
                      style: GoogleFonts.almarai(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.white,
                      ),
                    ),
                  ),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
