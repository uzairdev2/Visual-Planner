import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Core/helper/helper.dart';
import '../../../Core/routes/routes.dart';
import '../../Accepted Sprints Screen/accepted_sprints_screen.dart';
import '../../Splash Screen/splash_screen.dart';
import '../../Sprint Details Screen/sprint_details_screen.dart';
import '../components/shared_components/progress_report_card.dart';

SizedBox fixheight = SizedBox(
  height: 20,
);

class SprintScreen extends StatelessWidget {
  SprintScreen({required this.Projectid, super.key});
  String Projectid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(
            ScreenName: "Sprints Screen",
          )),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            Card(
              color: Colors.amber[100],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Sprint',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Get.toNamed(Routes.CreateSprint);
                        // Handle button press
                      },
                    ),
                  ],
                ),
              ),
            ),
            fixheight,
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Sprints')
                    .where('projectId', isEqualTo: Projectid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.CreateSprint);
                      },
                      child: const ProgressReportCard(
                        data: ProgressReportCardData(
                          title: "No Sprint",
                          doneTask: 0,
                          percent: 0,
                          task: 0,
                          undoneTask: 0,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];

                          return InkWell(
                              onTap: () {
                                // Get.toNamed(Routes.SprintDetails);
                                Get.to(SprintDetailsScreen(
                                  data: data.data(),
                                ));
                              },
                              child: Card(
                                child: Container(
                                  height: 180,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromRGBO(129, 120, 183, 1),
                                        Color.fromRGBO(65, 139, 128, 1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(kBorderRadius),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          CommonRow(
                                            details: data["projectName"],
                                            title: "Project Name",
                                          ),
                                          CommonRow(
                                            details: data["sprintName"],
                                            title: "Sprint Name",
                                          ),
                                        ],
                                      ),

                                      Column(
                                        children: [
                                          CommonRow(
                                            details: data["startingDate"],
                                            title: "Sprint Start Date:",
                                          ),
                                          CommonRow(
                                            details: data["endingDate"],
                                            title: "Sprint End Date:",
                                          ),
                                        ],
                                      ),

                                      //copy complete row
                                    ],
                                  ),
                                ),
                              )

                              // ProgressReportCard(
                              //   data: ProgressReportCardData(
                              //     title: "${data["sprintName"]}",
                              //     doneTask: 5,
                              //     percent: .4,
                              //     task: 3,
                              //     undoneTask: 112,
                              //   ),
                              // ),

                              );
                        });
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class CommonAppBar extends StatelessWidget {
  CommonAppBar({
    super.key,
    required this.ScreenName,
    this.customwidget,
  });
  String ScreenName;
  Widget? customwidget;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: size.height * 0.1,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
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
          SizedBox(
            width: size.width * 0.18,
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
          customwidget ?? SizedBox.shrink()
        ],
      ),
    );
  }
}

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
        flex: 6,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Text(
          details,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ]);
  }
}
