import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visual_planner/Core/routes/routes.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/SprintScreen/sprint.dart';

import '../../Core/controllers/dashboardController.dart';
import '../../Core/models/commonData.dart';
import '../Splash Screen/splash_screen.dart';
import 'TaskScreen/showAddedTask.dart';
import 'components/components/header.dart';
import 'components/components/profile_tile.dart';
import 'components/components/sidebar.dart';
import 'components/components/team_member.dart';
import 'components/shared_components/get_premium_card.dart';
import 'components/shared_components/list_profile_image.dart';
import 'components/shared_components/progress_card.dart';
import 'components/shared_components/progress_report_card.dart';
import 'components/shared_components/responsive_builder.dart';
import '../../Core/helper/helper.dart';
import '../../Core/models/profile.dart';

class DashboardScreen extends StatelessWidget {
  final dashboardController = DashboardController();
  DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("here is userid $userid");
    log("here is userid ${commonModel.userid}");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: dashboardController.scafolKey,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: kSpacing),
          child: SIDEBAR(
            data: dashboardController.getSelectedProject(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kSpacing * (kIsWeb ? 1 : 2),
            ),
            buildHeader(
              onPressedMenu: () => dashboardController.openDrawer(),
            ),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            buildProfile(data: dashboardController.getProfil()),
            const SizedBox(height: kSpacing),
            Text("Your Accepted WorkSpace",
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Invitations')
                  .where('recipientEmails', isEqualTo: commonModel.email)
                  .where(
                    'status',
                    isEqualTo: 'Accepted',
                  )
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    "No Sprint here",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ));
                } else {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Sprints')
                        .where('sprintName',
                            isEqualTo: snapshot.data!.docs[0]["sprintName"])
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ));
                      } else {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];

                                return InkWell(
                                    onTap: () {
                                      Get.to(ShowAddedTask(
                                          Sprintid: data["projectId"],
                                          Sprintname: data["sprintName"]));
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
                                          borderRadius: BorderRadius.circular(
                                              kBorderRadius),
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
                              }),
                        );
                      }
                    },
                  );
                }
              },
            ),
            Text("Your Own workSpace",
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Projects')
                    .where('userId', isEqualTo: userid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.addProject);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Transform.translate(
                                  offset: const Offset(10, 30),
                                  child: const SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Image(
                                      image: AssetImage(
                                          "assets/images/happy-2.png"),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: kSpacing,
                                top: kSpacing,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "No Project Yet",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    "Working on a new track...",
                                    style:
                                        TextStyle(color: kFontColorPallets[1]),
                                  ),
                                  const SizedBox(height: kSpacing),
                                ],
                              ),
                            ),
                          ],
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
                              Get.to(SprintScreen(
                                Projectid: data["projectId"],
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(kBorderRadius),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Transform.translate(
                                        offset: const Offset(10, 30),
                                        child: const SizedBox(
                                          height: 200,
                                          width: 200,
                                          child: Image(
                                            image: AssetImage(
                                                "assets/images/happy-2.png"),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: kSpacing,
                                      top: kSpacing,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data["projectName"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 30,
                                          ),
                                        ),
                                        Text(
                                          "Working on a new track...",
                                          style: TextStyle(
                                              color: kFontColorPallets[1]),
                                        ),
                                        const SizedBox(height: kSpacing),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            ),
            const SizedBox(height: kSpacing),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          const Expanded(child: Header()),
        ],
      ),
    );
  }

  Widget buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                log("tab here");
              },
              child: ProgressCard(
                data: const ProgressCardData(
                  totalUndone: 12,
                  totalTaskInProress: 2,
                ),
                onPressedCheck: () {
                  log("off");
                },
              ),
            ),
            const SizedBox(height: kSpacing / 2),
          ],
        ));
  }

  Widget buildProfile({required Profile data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: ProfilTile(
        data: data,
        onPressedNotification: () {},
      ),
    );
  }
}
