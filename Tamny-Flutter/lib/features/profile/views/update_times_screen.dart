import 'package:doctor/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/background_image/custom_background.dart';
import '../controller/schedule_cubit.dart';

class SetScheduleInputPage extends StatefulWidget {
  const SetScheduleInputPage({super.key});

  @override
  State<SetScheduleInputPage> createState() => _SetScheduleInputPageState();
}

class _SetScheduleInputPageState extends State<SetScheduleInputPage> {
  String selectedDay = 'monday';
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final sessionDurationController = TextEditingController();

  final days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  Future<void> pickTime({required bool isStartTime}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );



    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }





  @override
  void dispose() {
    sessionDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScheduleCubit>();

    return Scaffold(
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 250.0, left: 20.0, right: 20),
          child: BlocConsumer<ScheduleCubit, ScheduleState>(
            listener: (context, state) {
              if (state is ScheduleFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')),
                );

                print(state.error);
              }

              if (state is ScheduleSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Schedule created successfully!')),
                );

                // Reset fields
                setState(() {
                  startTime = null;
                  endTime = null;
                  sessionDurationController.clear();
                  selectedDay = 'monday';
                });
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Day"),
                  DropdownButton<String>(
                    value: selectedDay,
                    items: days
                        .map((day) => DropdownMenuItem(
                      value: day,
                      child: Text(day.toUpperCase()),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedDay = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Start Time"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.button,
                                foregroundColor: Colors.white,
                                shadowColor: AppColors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => pickTime(isStartTime: true),
                              child: Text(startTime == null
                                  ? "Pick Time"
                                  : formatTimeOfDay(startTime!)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("End Time"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.button,
                                foregroundColor: Colors.white,
                                shadowColor: AppColors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => pickTime(isStartTime: false),
                              child: Text(endTime == null
                                  ? "Pick Time"
                                  : formatTimeOfDay(endTime!)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: sessionDurationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Session Duration (in minutes)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        foregroundColor: Colors.white,
                        shadowColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        print("Formatted time: ${formatTimeOfDay(startTime!)}");
                        print("Formatted time: ${formatTimeOfDay(endTime!)}");


                        if (startTime != null &&
                            endTime != null &&
                            sessionDurationController.text.isNotEmpty) {
                          final startMinutes = startTime!.hour * 60 + startTime!.minute;
                          final endMinutes = endTime!.hour * 60 + endTime!.minute;

                          if (startMinutes >= endMinutes) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Start time must be before end time')),
                            );
                            return;
                          }

                          final duration = int.tryParse(sessionDurationController.text);
                          if (duration == null || duration <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter valid session duration')),
                            );
                            return;
                          }

                          cubit.setSchedule(
                            day: selectedDay,
                            startTime: "${formatTimeOfDay(startTime!)} AM",
                            endTime: "${formatTimeOfDay(endTime!)} pm",
                            sessionDuration: duration,
                          );

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please complete all fields')),
                          );
                        }
                      },
                      child: const Text("Create Schedule"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state is ScheduleLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
