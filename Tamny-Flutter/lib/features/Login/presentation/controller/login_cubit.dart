import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../data/model/usermodel.dart';
import '../../data/repo/login_repo.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this.loginRepo) : super(LoginInitial());

  TextEditingController  Email = TextEditingController();
  TextEditingController password = TextEditingController();

  final LoginRepo loginRepo ;

  Future<void> login()  async{

    emit(LoginLoadingState());
    var result = await loginRepo.login(
      email: Email.text.trim(),
      pass: password.text.trim() );
    result.fold((left) {
      if (left.message == "Your account is not verified yet") {
        emit(LoginNotApprovedState());
      } else {
        emit(LoginFailureState(errorMessage: left.message));
      }
    }, (right) async {

      var box = Hive.box("setting");
      // احفظ القيم
      await box.put("id", right.id);
      await box.put("Iddoctor", right.doctorid);
      await box.put("token", right.token);
      // اطبع للتأكد
      print("ID :::::::::::: ${box.get("id")}");
      print("Token :::::::::::: ${box.get("token")}");
      print("Iddoctor :::::::::::: ${box.get("Iddoctor")}");
      emit(LoginSuccessState(userModel: right));
    });


  }


}
