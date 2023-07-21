import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Core/common/common_snackBar.dart';
import '../../Core/common/common_text_field.dart';
import '../../Core/common/wide_filled_button.dart';
import '../../Core/helper/helper.dart';
import '../Send Invitation Screen/send_invitation_screen.dart';

class CreateSprintScreen extends StatefulWidget {
  const CreateSprintScreen({super.key});

  @override
  State<CreateSprintScreen> createState() => _CreateSprintScreenState();
}

class _CreateSprintScreenState extends State<CreateSprintScreen> {
  TextEditingController sprintNameController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  DateFormat dateFormat =
      DateFormat("yyyy-MM-dd"); // For formatting the selected date.

  // Function to show the calendar popup and update the selected date in the text field.
  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != controller.text) {
      controller.text = dateFormat.format(pickedDate);
    }
  }

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
                          "assets/images/sprint.png",
                        ),
                        height: size.height * 0.22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        "Add your Sprint!",
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
                      hintText: "Sprint Name",
                      controller: sprintNameController,
                      minLength: 1,
                      draggable: false,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CommonTextField(
                      hintText: 'Starting Date',
                      controller: startTimeController,
                      icon: Icons.keyboard_double_arrow_right,
                      keyboardType: TextInputType.datetime,
                      draggable: false,
                      minLength: 1,
                      iconButton: IconButton(
                        onPressed: () {
                          _selectDate(startTimeController);
                        },
                        icon: Icon(Icons.calendar_month),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CommonTextField(
                      hintText: 'Ending Date',
                      controller: endTimeController,
                      icon: Icons.keyboard_double_arrow_left,
                      keyboardType: TextInputType.datetime,
                      draggable: false,
                      minLength: 1,
                      iconButton: IconButton(
                        onPressed: () {
                          _selectDate(endTimeController);
                        },
                        icon: Icon(Icons.calendar_month),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    WideFilledButton(
                      btnText: 'Create Sprint',
                      onTap: () {
                        // Get the current user
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          // If there is no logged in user, display an error message
                          Get.snackbar('Error', 'You need to log in first!');
                          return;
                        }
                        // Check the textfields are empty or not
                        if (sprintNameController.text.isEmpty ||
                            startTimeController.text.isEmpty ||
                            endTimeController.text.isEmpty) {
                          // show error toast
                          costumSnackbar('Empty Fields',
                              "Please Enter Sprint Name, start Time, and End Time ");
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendInvitationScreen(
                              sprintData: SprintData(
                                  sprintName: sprintNameController.text.trim(),
                                  startingDate: startTimeController.text.trim(),
                                  endingDate: endTimeController.text.trim()),
                            ),
                          ),
                        );
                      },
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class SprintData {
  final String sprintName;
  final String startingDate;
  final String endingDate;

  SprintData({
    required this.sprintName,
    required this.startingDate,
    required this.endingDate,
  });
}
