import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../Core/common/common_text_field.dart';
import '../../Core/common/wide_filled_button.dart';
import '../../Core/common/wide_outlined_button.dart';
import '../../Core/controllers/Auth Controllers/auth_controllers.dart';
import '../../Core/helper/helper.dart';
import '../../Core/routes/routes.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController addressController = TextEditingController();

  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  final RegExp phoneRegex = RegExp(r'^\+?\d{8,15}$');

  void clearText() {
    userNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final signUpProvider = Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 162, 224, 214),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: Get.height,
          width: Get.width,
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: SingleChildScrollView(
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
                  Center(
                    child: Image(
                      image: const AssetImage(
                        "assets/images/happy.png",
                      ),
                      height: size.height * 0.15,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Get On Board!",
                      style: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Create your profile to start your journey",
                    style: GoogleFonts.ubuntu(
                        // color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextField(
                    icon: Icons.person_outline_outlined,
                    hintText: "Your Name",
                    controller: userNameController,
                    minLength: 1,
                    draggable: false,
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
                  IntlPhoneField(
                    controller: phoneController,
                    initialCountryCode: '90',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      hintText: "Phone Number",
                      contentPadding: const EdgeInsets.fromLTRB(35, 16, 20, 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide:
                            const BorderSide(color: primaryColor, width: 1.5),
                      ),
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    onCountryChanged: (country) {
                      print('Country changed to: ' + country.name);
                    },
                  ),
                  CommonTextField(
                    enablestate: 2,
                    icon: Icons.fingerprint,
                    hintText: "Password",
                    controller: passwordController,
                    minLength: 1,
                    draggable: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: WideFilledButton(
                      btnText: "Sign Up",
                      onTap: () async {
                        signUpProvider.SignUp(
                          context,
                          emailController,
                          userNameController,
                          phoneController,
                          passwordController,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      const Text(
                        "OR",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      WideOutlinedButton(
                        btnText: "Google",
                        onTap: () {
                          signUpProvider.googleLogin(context);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have Account?",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (Get.previousRoute == '/login') {
                            Get.back();
                          } else {
                            Get.toNamed(Routes.login);
                          }
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SnackbarController costumSnackbar(String title, String message) {
    return Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: Colors.black,
      duration: const Duration(seconds: 5),
      icon: const Icon(
        Icons.warning_amber,
        color: Colors.white,
      ),
    );
  }
}
