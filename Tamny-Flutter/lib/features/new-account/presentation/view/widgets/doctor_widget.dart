import 'package:doctor/features/Login/presentation/view/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:doctor/features/new-account/presentation/view/widgets/txtfield_time.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_texts.dart';
import '../../../../Login/presentation/view/widgets/custom_Button.dart';
import '../../../../Login/presentation/view/widgets/custom_row_field.dart';
import '../../../data/model/location_model.dart';
import '../../../data/model/spclazition_model.dart';
import '../../controller/doctoraccount_cubit.dart';

class DocWidget extends StatefulWidget {
  const DocWidget({super.key});

  @override
  State<DocWidget> createState() => _DocWidgetState();
}

class _DocWidgetState extends State<DocWidget> {
  List<LocationModel> locations = [];
  List<SpecializationModel> specialization = [];
  LocationModel? selectedLocation;
  SpecializationModel? selectedSpecialization;

  final TextEditingController streetController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLocations();
    loadSpecializations();
  }

  Future<void> loadLocations() async {
    try {
      final result = await fetchLocations();
      setState(() => locations = result);
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  Future<void> loadSpecializations() async {
    try {
      final result = await fetchSpecializations();
      setState(() => specialization = result);
    } catch (e) {
      print('Error fetching specializations: $e');
    }
  }

  InputDecoration inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.grey),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
  );

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<DoctoraccountCubit>(context);

    return BlocConsumer<DoctoraccountCubit, DoctoraccountState>(
      listener: (context, state) {
        if (state is GreateAccountDocFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
        if (state is GreateAccountDocSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created successfully')));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      },
      builder: (context, state) {
        if (state is GreateAccountDocLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.only(top: 7,left: 17,right: 17),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRowField(txt: AppTexts.name, controller: cubit.userName),
                SizedBox(height: 16.h),
                CustomRowField(txt: AppTexts.email, controller: cubit.Email),
                SizedBox(height: 16.h),
                CustomRowField(txt: "كنية", controller: cubit.nickNameCon),
                SizedBox(height: 16.h),
                CustomRowField(txt: AppTexts.pass, controller: cubit.password),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomRowField_time(txt: "رقم الهاتف",controller: cubit.phoneCon,),
                    CustomRowField_time(txt: AppTexts.price, controller: cubit.pricecon),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("الموقع", style: GoogleFonts.almarai(color: AppColors.white, fontSize: 15.sp, fontWeight: FontWeight.w700)),
                    Text("التخصص", style: GoogleFonts.almarai(color: AppColors.white, fontSize: 15.sp, fontWeight: FontWeight.w700)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<LocationModel>(
                              isExpanded: true,
                              hint: const Text('Choose Location', style: TextStyle(fontSize: 16)),
                              items: locations.map((loc) {
                                return DropdownMenuItem<LocationModel>(
                                  value: loc,
                                  child: Text(loc.name, style: const TextStyle(fontSize: 16)),
                                );
                              }).toList(),
                              value: selectedLocation,
                              onChanged: (value) => setState(() => selectedLocation = value),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<SpecializationModel>(
                              isExpanded: true,
                              hint: const Text('Choose Specialization', style: TextStyle(fontSize: 16)),
                              items: specialization.map((spec) {
                                return DropdownMenuItem<SpecializationModel>(
                                  value: spec,
                                  child: Text(spec.name, style: const TextStyle(fontSize: 16)),
                                );
                              }).toList(),
                              value: selectedSpecialization,
                              onChanged: (value) => setState(() => selectedSpecialization = value),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextField(controller: streetController, style: const TextStyle(fontSize: 14), decoration: inputDecoration("أدخل الشارع"))),
                    SizedBox(width: 10),
                    Expanded(child: TextField(controller: cubit.areaCon, style: const TextStyle(fontSize: 14), decoration: inputDecoration("أدخل المدينة"))),
                  ],
                ),
                SizedBox(height: 10),
                TextField(controller: cubit.descriptionCon, style: const TextStyle(fontSize: 14), decoration: inputDecoration("الوصف ")),
                SizedBox(height: 10),


                Center(
                  child: CustomButton(
                    txt: AppTexts.register,
                    onPressed: () {
                      context.read<DoctoraccountCubit>().GreateacoountDoctor(
                        context,
                        location: selectedLocation?.id,
                        specialization: selectedSpecialization?.id,
                      );
                      print("Selected Location: ${selectedLocation?.name}");
                      print("Selected Specialization: ${selectedSpecialization?.name}");
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
