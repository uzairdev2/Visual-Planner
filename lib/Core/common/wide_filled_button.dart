import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WideFilledButton extends StatelessWidget {
  const WideFilledButton({Key? key, required this.btnText, required this.onTap})
      : super(key: key);
  final String btnText;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.06,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black
            // borderRadius: BorderRadius.circular(15),
            ),
        child: Center(
          child: Text(
            btnText,
            style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
