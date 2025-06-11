import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseSick extends StatefulWidget {
  final List<String> specialties;
  final Function(String) onSelected;
  final String? initialSelected;

  const ChooseSick({
    super.key,
    required this.specialties,
    required this.onSelected,
    this.initialSelected,
  });

  @override
  State<ChooseSick> createState() => _ChooseSickState();
}

class _ChooseSickState extends State<ChooseSick> {
  bool isExpanded = false;
  String? selectedSpecialty;

  @override
  void initState() {
    super.initState();
    selectedSpecialty = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            width: 250.w,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              selectedSpecialty ?? "التخصصات",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: widget.specialties.map((specialty) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSpecialty = specialty;
                      isExpanded = false;
                    });
                    widget.onSelected(specialty);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        specialty,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}