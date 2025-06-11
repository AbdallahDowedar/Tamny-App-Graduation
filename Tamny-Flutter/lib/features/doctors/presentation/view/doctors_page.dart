import 'package:doctor/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/background_image/custom_background.dart';
import '../../data/repo/doctors-repo-implementation.dart';
import '../controller/doctors_cubit.dart';
import '../controller/doctors_state.dart';

class DoctorsPage extends StatelessWidget {
  const DoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorCubit(DoctorsRepoImplementation())..getDoctors(),
      child: Scaffold(
        body: CustomBackground(
          child:BlocBuilder<DoctorCubit, DoctorState>(
            builder: (context, state) {
              if (state is DoctorLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.button,));
              } else if (state is DoctorError) {
                return Center(child: Text("Error: ${state.message}"));
              } else if (state is DoctorLoaded) {
                final doctors = state.doctors.where((doctor) => doctor.isVerified == false).toList();

                // final doctors = state.doctors;
                if (doctors.isEmpty) {
                  return const Center(child: Text("No doctors found"));
                }
                return Column(
                  children: [

                    SizedBox(height: 170,),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                        child: ListView.builder(
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];
                            return Card(
                              color: Colors.white.withOpacity(0.05),

                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.button.withOpacity(0.8),
                                  child: Text(doctor.user?.userName![0] ?? '?'),
                                ),
                                title: Column(
                                  children: [
                                    Text(
                                      doctor.user?.userName ?? 'No name',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),  Text(
                                      doctor.description ?? 'No name',
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 3,
                                    ),Text(
                                      doctor.locations?.name ?? '',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      doctor.specialization?.name ?? '',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context.read<DoctorCubit>().approveDoctor(doctor.id!);
                                        },
                                        icon: Icon(Icons.check_circle, color: Colors.greenAccent),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context.read<DoctorCubit>().rejectDoctor(doctor.id!);
                                        },
                                        icon: Icon(Icons.cancel, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox(); // initial
            },
          ),
        )

      ),
    );
  }
}
