import 'package:doctor/core/utils/app_colors.dart';
import 'package:doctor/features/new-account/presentation/view/widgets/sickk_widget.dart';
import 'package:doctor/features/new-account/presentation/view/widgets/doctor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/background_image/custom_background.dart';
import '../../data/repo/Greate_account_impelemntation.dart';
import '../controller/greateaccount_cubit.dart';
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue.shade50,
      body: CustomBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 120.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Color(0xff95d8e5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xff95d8e5),
                    tabs: [
                      Tab(text: "تسجيل\n طبيب"),
                      Tab(text: "تسجيل\n مريض"),


                    ],
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  height: 650.h,
                  child: TabBarView(
                    controller: _tabController,
                    children: [

                      DocWidget(),

                      BlocProvider(
                       create: (context) => GreateAccountCubit(GreateAccountImplementation()),
                     child: SickWidget(),) ,

                    ],
                  ),
                ),


              ],
            ),

          ),
        ),
      ),
    );
  }


}

