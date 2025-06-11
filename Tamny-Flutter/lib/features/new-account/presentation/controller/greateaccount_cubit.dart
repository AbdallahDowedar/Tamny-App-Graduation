import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // لإضافة مكتبة dart:convert
import 'dart:io';
import '../../data/model/new_account_model.dart';
import '../../data/repo/Greate_account_repo.dart';
import 'greateaccount_state.dart';

class GreateAccountCubit extends Cubit<GreateAccountState> {
  GreateAccountCubit(this.greateAccountRepo) : super(GreateAccountInitial());

  final TextEditingController Email = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();

  final GreateAccountRepo greateAccountRepo;

  Future<void> Greateacoount(BuildContext context) async {
    emit(GreateAccountLoadingState());
    try {
      final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(Email.text.trim());

      if (!emailValid) {
        emit(GreateAccountFailureState(errorMessage: "Please enter a correct email."));
      } else if (userName.text.isEmpty) {
        emit(GreateAccountFailureState(errorMessage: "Name cannot be empty."));
      } else if (password.text.isEmpty) {
        emit(GreateAccountFailureState(errorMessage: "Password cannot be empty."));
      } else if (password.text != cpassword.text) {
        emit(GreateAccountFailureState(errorMessage: "Passwords do not match."));
      } else {
        var result = await greateAccountRepo.Greate_account_Sick(
          userModelToRegister: UserModelToRegister(
            username: userName.text,
            email: Email.text.trim(),
            password: password.text.trim(),
            cpassword: cpassword.text.trim(),
          ),
        );

        result.fold(
              (left) {
            emit(GreateAccountFailureState(errorMessage: left.message));
            print(left.message);
          },
              (right) async {
            emit(GreateAccountSuccessState(userModelToRegister: right));
          },
        );
      }
    } catch (e) {
      emit(GreateAccountFailureState(errorMessage: "An unexpected error occurred."));
    }
  }
}


