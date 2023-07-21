import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/dashboard_screen.dart';

import '../../../Core/helper/helper.dart';
import '../../../Core/models/commonData.dart';

SizedBox fixheight = const SizedBox(
  height: 20,
);
SizedBox fixheight2 = const SizedBox(
  height: 10,
);

class InvaitionScreen extends StatelessWidget {
  const InvaitionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CommonAppBar(
          ScreenName: "Invitation Screen",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              fixheight,
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Invitations')
                      .where('recipientEmails', isEqualTo: commonModel.email)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Invitation Found",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];

                            return data["status"] == "Pending"
                                ? Card(
                                    child: Container(
                                      // height: 220,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromRGBO(224, 220, 90, 1),
                                            Color.fromRGBO(136, 75, 45, 1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            kBorderRadius),
                                      ),
                                      child: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "-: Send Invitation Email :----",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "  ${data["senderEmail"]}",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          fixheight,
                                          CommonRow(
                                            details: data["sprintName"],
                                            title: "Sprint Name:",
                                          ),
                                          CommonRow(
                                            details: data["startingDate"],
                                            title: "Sprint Start Date:",
                                          ),
                                          CommonRow(
                                            details: data["endingDate"],
                                            title: "Sprint End Date:",
                                          ),
                                          CommonRow(
                                            details: data["status"],
                                            title: "Invitation Status:",
                                          ),
                                          fixheight2,
                                          Text(
                                            "if you want to accept the Invitation, click 'Accept' below.",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Invitations')
                                                      .doc(data.id)
                                                      .update({
                                                    "status": "Accepted",
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  QuickAlert.show(
                                                    context: context,
                                                    type:
                                                        QuickAlertType.success,
                                                    title:
                                                        "Invitation Accepted",
                                                    backgroundColor:
                                                        Colors.grey.shade700,
                                                    titleColor: Colors.white,
                                                  );
                                                },
                                                child: const Text("Accept"),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              ElevatedButton(
                                                style: const ButtonStyle(
                                                    // backgroundColor: Color.fromARGB(255, 218, 78, 68),
                                                    ),
                                                onPressed: () async {
                                                  QuickAlert.show(
                                                    context: context,
                                                    type:
                                                        QuickAlertType.confirm,
                                                    text:
                                                        'Do you want to delete the Invitation?',
                                                    confirmBtnText: 'Yes',
                                                    cancelBtnText: 'No',
                                                    confirmBtnColor: Colors.red,
                                                    onConfirmBtnTap: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Invitations')
                                                          .doc(data.id)
                                                          .delete();
                                                      Get.offAll(
                                                        DashboardScreen(),
                                                      );
                                                    },
                                                    onCancelBtnTap: () {
                                                      Get.back();
                                                    },
                                                  );
                                                },
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CommonAppBar extends StatelessWidget {
  CommonAppBar({
    super.key,
    // ignore: non_constant_identifier_names
    required this.ScreenName,
  });
  // ignore: non_constant_identifier_names
  String ScreenName;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: size.height * 0.1,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              child: const Icon(
                Icons.arrow_back,
                color: primaryColor,
                size: 20,
              ),
            ),
          ),
          Center(
            child: Text(
              ScreenName,
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox.shrink()
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CommonRow extends StatelessWidget {
  CommonRow({
    super.key,
    required this.details,
    required this.title,
  });

  // final QueryDocumentSnapshot<Object?> data;
  String title;
  String details;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 5,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Text(
          details,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ]);
  }
}
