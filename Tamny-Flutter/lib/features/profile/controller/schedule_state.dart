part of 'schedule_cubit.dart';

@immutable
abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleSuccess extends ScheduleState {
  final List<DaySlotsModel> slots;

  ScheduleSuccess(this.slots);
}

class ScheduleFailure extends ScheduleState {
  final String error;

  ScheduleFailure(this.error);
}
