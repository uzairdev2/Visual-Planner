import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visual_planner/Core/helper/helper.dart';
import 'package:visual_planner/Core/routes/routes.dart';

import '../../Core/models/Users Data/json_model.dart';
import '../../Core/models/commonData.dart';

String? finalEmail;
String? userid;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(Duration(seconds: 3), () async {
        if (finalEmail != null) {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          log("inside $userid ");
          // userid = "6IBzOYyZqIVVLlbshB6N9cRVt6Z2";
          var data = await FirebaseFirestore.instance
              .collection('userCredential')
              .doc(userid)
              .get();
          if (data.exists) {
            log("data fount");

            commonModel = UserModels.fromJson(data.data());

            Get.offAllNamed(Routes.dashboard);
          }
        } else {
          Get.toNamed(Routes.onBoardingOne);
        }
      });
    });
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var ObtainedEmail = sharedPreferences.getString('email');
    userid = sharedPreferences.getString('userid');

    setState(() {
      finalEmail = ObtainedEmail;

      userid = userid;
    });

    print('Final email: $finalEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                secondaryColor,
                primaryColor,
              ],
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.2),
                child: SizedBox(
                  height: 176,
                  width: 176,
                  child: Image.asset(
                    "assets/images/prioritize.png",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 196,
                child: Text(
                  "Virtual Planner",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
