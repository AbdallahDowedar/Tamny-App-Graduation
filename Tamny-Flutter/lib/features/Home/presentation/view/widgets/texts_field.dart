import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Booktxtfield extends StatelessWidget {
  const Booktxtfield({super.key, required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Container(
        width: 250.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(

          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
    );
  }
}


class locationfield extends StatelessWidget {
  const locationfield({super.key, required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Container(
        width: 250.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.location_on, color: Colors.redAccent),
            ),
            Expanded(
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
