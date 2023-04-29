import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Core/common/common_text_field.dart';
import '../../Core/common/wide_filled_button.dart';
import '../../Core/common/wide_outlined_button.dart';
import '../../Core/controllers/Auth Controllers/auth_controllers.dart';
import '../../Core/helper/helper.dart';
import '../../Core/routes/routes.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isRemeberme = false;

  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final signInProvider = Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 162, 224, 214),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: Get.height,
          width: Get.width,
          //color: Colors.white,
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
                      height: size.height * 0.2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      "Welcome Back!",
                      style: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Make it work, make it right, make it fast",
                    style: GoogleFonts.poppins(
                        //color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextField(
                    icon: Icons.email,
                    hintText: "Email Address",
                    controller: emailController,
                    minLength: 1,
                    draggable: false,
                  ),
                  CommonTextField(
                    icon: Icons.fingerprint,
                    hintText: "Password",
                    controller: passwordController,
                    minLength: 1,
                    draggable: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.forgotPassword);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: WideFilledButton(
                      btnText: "Login",
                      onTap: () async {
                        signInProvider.SignIn(
                          context,
                          emailController,
                          passwordController,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                        onTap: () async {
                          signInProvider.googleLogin(context);
                          // Get.toNamed(Routes.dashboard);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't Have Account?",
                        style: GoogleFonts.ubuntu(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (Get.previousRoute == '/signUp') {
                            Get.back();
                          } else {
                            Get.toNamed(Routes.signUp);
                          }
                        },
                        child: Text(
                          " Sign Up",
                          style: GoogleFonts.ubuntu(
                              fontSize: 16,
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
}
