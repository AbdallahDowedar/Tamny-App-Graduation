
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/Routes/app_routes.dart';
import 'core/Routes/router_generator.dart';
import 'features/Login/data/repo/login_repo_implementation.dart';
import 'features/Login/presentation/controller/login_cubit.dart';
import 'features/ai/chat_cubit.dart';
import 'features/new-account/data/repo/Greate_account_impelemntation.dart';
import 'features/new-account/presentation/controller/doctoraccount_cubit.dart';
import 'features/new-account/presentation/controller/greateaccount_cubit.dart';
import 'features/profile/controller/schedule_cubit.dart';
import 'features/profile/data/repo/schedule_repo.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("setting");
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 1006),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return  MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => GreateAccountCubit(GreateAccountImplementation(),)),
            BlocProvider(create: (context) => LoginCubit(LoginRepoImplementation(),)) ,
            BlocProvider(  create: (context) => DoctoraccountCubit(GreateAccountImplementation(),),),
            BlocProvider(  create: (context) => ScheduleCubit( ScheduleRepo()),),
            BlocProvider(create: (_) => ChatCubit(),)

          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'طمني',
            initialRoute: AppRoutes. loginpage,
            onGenerateRoute: RouterGenerator().generateRoute,
            // home:  ChatPage(),
          ),
        );
      },

    );
  }
}
