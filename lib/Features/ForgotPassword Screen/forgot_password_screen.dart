import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:visual_planner/Core/controllers/Auth%20Controllers/auth_controllers.dart';

import '../../Core/common/common_text_field.dart';
import '../../Core/common/wide_filled_button.dart';
import '../../Core/helper/helper.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final resetPassword = Provider.of<AuthController>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(237, 244, 243, 1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20 * 4,
                ),
                Center(
                  child: Image(
                    image: const AssetImage(
                      "assets/images/moon.png",
                    ),
                    height: size.height * 0.2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Text(
                      "Forget Password",
                      style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      //: TextAlign.center,
                    ),
                  ),
                ),
                Text(
                  "Select one of the options given below to reset your password",
                  style: GoogleFonts.poppins(
                      //color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                CommonTextField(
                  icon: Icons.email,
                  hintText: "Email Address",
                  controller: emailController,
                  minLength: 1,
                  draggable: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: WideFilledButton(
                    btnText: "Next",
                    onTap: () async {
                      resetPassword.resetPassword(context, emailController);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
