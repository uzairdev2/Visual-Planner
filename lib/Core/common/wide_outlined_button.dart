import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WideOutlinedButton extends StatelessWidget {
  const WideOutlinedButton(
      {Key? key, required this.btnText, required this.onTap})
      : super(key: key);
  final String btnText;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.06,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              //color: primaryColor,
              // width: 2,
              ),
          //borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            btnText,
            style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w400, fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
