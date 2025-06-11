import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/model/SlotModel.dart';
import '../data/repo/schedule_repo.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this.repo) : super(ScheduleInitial());

  final ScheduleRepo repo;

  List<DaySlotsModel> slotsList = [];

  Future<void> setSchedule({
    required String day,
    required String startTime,
    required String endTime,
    required int sessionDuration,
  }) async {
    emit(ScheduleLoading());

    try {
      var box = Hive.box("setting");
      String doctorId = box.get("Iddoctor");

      final slots = await repo.setSchedule(
        doctorId: doctorId,
        sessionDuration: sessionDuration,
        day: day,
        startTime: startTime,
        endTime: endTime,
      );

      slotsList = slots;
      emit(ScheduleSuccess(slots));
    } catch (e) {
      emit(ScheduleFailure(e.toString()));
    }
  }
}
