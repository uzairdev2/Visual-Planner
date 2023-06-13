import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Core/Firestore Services/firestore_services.dart';
import '../../Core/common/common_text_field.dart';
import '../../Core/common/wide_filled_button.dart';
import '../../Core/helper/helper.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  TextEditingController projectNameController = TextEditingController();
  TextEditingController discreptionController = TextEditingController();

  void clearText() {
    projectNameController.clear();
    discreptionController.clear();
  }

  FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                          "assets/images/project.png",
                        ),
                        height: size.height * 0.22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        "Add your project!",
                        style: GoogleFonts.ubuntu(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CommonTextField(
                      icon: Icons.rocket_launch,
                      hintText: "Project Name",
                      controller: projectNameController,
                      minLength: 1,
                      draggable: false,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CommonTextField(
                      hintText: 'Project Description',
                      controller: discreptionController,
                      icon: Icons.description_outlined,
                      keyboardType: TextInputType.multiline,
                      minLength: 3,
                      draggable: true,
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    WideFilledButton(
                      btnText: 'Create Project',
                      onTap: () {
                        // if (projectNameController.text.isNotEmpty &&
                        //     discreptionController.text.isNotEmpty) {
                        //   Get.snackbar("Error", "Requrid all fields",
                        //       snackPosition: SnackPosition.BOTTOM);
                        // } else {
                        _firestoreService.uploadProjectData(
                          context,
                          projectNameController,
                          discreptionController,
                        );
                        clearText();
                        // }
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
