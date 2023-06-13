import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:visual_planner/Core/models/commonData.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/SprintScreen/sprint.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/TaskScreen/TaskScreen.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/TaskScreen/taskshowModel.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/components/components/recent_messages.dart';
import 'package:visual_planner/Features/Splash%20Screen/splash_screen.dart';

import '../../../Core/controllers/dashboardController.dart';
import '../../../Core/helper/helper.dart';
import '../components/components/active_project_card.dart';
import '../components/components/overview_header.dart';
import '../components/components/team_member.dart';
import '../components/shared_components/chatting_card.dart';
import '../components/shared_components/get_premium_card.dart';
import '../components/shared_components/list_profile_image.dart';
import '../components/shared_components/project_card.dart';
import '../components/shared_components/task_card.dart';

class ShowAddedTask extends StatefulWidget {
  ShowAddedTask({required this.Sprintname, required this.Sprintid, super.key});
  String Sprintname;
  String Sprintid;

  @override
  State<ShowAddedTask> createState() => _SprintDetailsScreenState();
}

final dashboardController = DashboardController();

class _SprintDetailsScreenState extends State<ShowAddedTask> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Axis headerAxis = Axis.horizontal;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: dashboardController.scafolKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(
            ScreenName: "Tasks Details",
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: kSpacing * 2),
              OverviewHeader(
                axis: Axis.vertical,
                onSelected: (task) {},
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Tasks')
                    .where('taskProjectId', isEqualTo: widget.Sprintid)
                    .where('taskSprint', isEqualTo: widget.Sprintname)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text(
                      "No task Yet",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];

                          taskModel activetask = taskModel
                              .fromJson(snapshot.data!.docs[index].data());

                          return InkWell(
                            onTap: () {
                              Get.to(ShowAddedTask(
                                  Sprintid: data["projectId"],
                                  Sprintname: data["sprintName"]));
                            },
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(kBorderRadius),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Tile(
                                        dotColor:
                                            activetask.taskStatusColor == "red"
                                                ? Colors.red
                                                : activetask.taskStatusColor ==
                                                        "green"
                                                    ? Colors.green
                                                    : Colors.yellow,

                                        title: activetask.taskName.toString(),
                                        subtitle: "assigned from" +
                                            activetask.taskProjectManager
                                                .toString(),
                                        // subtitle: "Due in " +
                                        //     ((activetask.dueto! > 1)
                                        //         ? "${activetask.dueto} days"
                                        //         : "today"),
                                        //         ((data.dueDay > 1) ? "${data.dueDay} days" : "today"),
                                        onPressedMore: () {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kSpacing),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: activetask
                                                          .taskStatusColor ==
                                                      "red"
                                                  ? Colors.red
                                                  : activetask.taskStatusColor ==
                                                          "green"
                                                      ? Colors.green
                                                      : Colors.yellow,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.defaultDialog(
                                                title: "Task Status",
                                                content: Column(
                                                  children: [
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .red)),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Tasks')
                                                            .doc(data.id)
                                                            .update({
                                                          "taskStatus": "Todo",
                                                          'taskStatusColor':
                                                              'red'
                                                        });
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                        "Todo",
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .yellow)),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Tasks')
                                                            .doc(data.id)
                                                            .update({
                                                          "taskStatus":
                                                              "In Progress",
                                                          'taskStatusColor':
                                                              'yellow'
                                                        });
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                        "In Progress",
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .green)),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Tasks')
                                                            .doc(data.id)
                                                            .update({
                                                          "taskStatus":
                                                              "Complete",
                                                          'taskStatusColor':
                                                              'green'
                                                        });
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                        "Complete",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onCancel: () {
                                                  Get.back();
                                                },
                                              );
                                            },
                                            child: Text(
                                              activetask.taskStatus.toString(),
                                            ),
                                          ),
                                          // ListProfilImage(
                                          //   images: activetask.taskMember,
                                          //   // onPressed: onPressedContributors,
                                          // ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing / 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kSpacing / 2),
                                      child: Row(
                                        children: [
                                          IconButtons(
                                            iconData:
                                                EvaIcons.messageCircleOutline,
                                            onPressed: () {
                                              TextEditingController
                                                  commentController =
                                                  TextEditingController();
                                              Get.bottomSheet(Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                                  height: 500,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                          flex: 8,
                                                          child: StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Tasks")
                                                                .doc(data.id)
                                                                .collection(
                                                                    "Comments")
                                                                .orderBy(
                                                                    "commentedOn",
                                                                    descending:
                                                                        true)
                                                                .snapshots(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return Center(
                                                                    child:
                                                                        CircularProgressIndicator());
                                                              }

                                                              return ListView
                                                                  .builder(
                                                                      itemCount: snapshot
                                                                          .data!
                                                                          .docs
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        var data = snapshot
                                                                            .data!
                                                                            .docs[index];
                                                                        return ListTile(
                                                                          leading:
                                                                              CircleAvatar(
                                                                            child:
                                                                                Text(data["commentedBy"][0]),
                                                                          ),
                                                                          title: Text(data["commentedBy"] == commonModel.name
                                                                              ? "You"
                                                                              : data["commentedBy"]),
                                                                          subtitle:
                                                                              Text(data["comment"]),
                                                                        );
                                                                      });
                                                            },
                                                          )),
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    top: BorderSide(
                                                                        color: Colors
                                                                            .grey))),
                                                            child:
                                                                TextFormField(
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  log("value");
                                                                  commentController
                                                                          .text =
                                                                      value;
                                                                });
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          "Type a comment",
                                                                      suffixIcon:
                                                                          IconButton(
                                                                        icon: Icon(
                                                                            Icons.send),
                                                                        onPressed:
                                                                            () {
                                                                          if (commentController.text ==
                                                                              "") {
                                                                            Get.snackbar("Empty Comment",
                                                                                "Please type a comment");
                                                                            return;
                                                                          } else {}

                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection("Tasks")
                                                                              .doc(data.id)
                                                                              .collection("Comments")
                                                                              .add({
                                                                            "comment":
                                                                                commentController.text,
                                                                            "commentedBy":
                                                                                commonModel.name,
                                                                            "commentedById":
                                                                                userid,
                                                                            "commentedOn":
                                                                                DateTime.now(),
                                                                            "likes":
                                                                                0,
                                                                          });
                                                                          commentController.text =
                                                                              "";
                                                                        },
                                                                      )),
                                                            ),
                                                          )),
                                                    ],
                                                  )));
                                            },
                                            totalContributors: 2,
                                          ),
                                          const SizedBox(width: kSpacing / 2),
                                          // IconButton(
                                          //   iconData: EvaIcons.peopleOutline,
                                          //   onPressed: ,
                                          //   totalContributors: data.totalContributors,
                                          // ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing / 2),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
              const SizedBox(height: kSpacing * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: data.length + 1,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (index == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: kSpacing),
                child: OverviewHeader(
                  // axis: headerAxis,
                  onSelected: (task) {},
                ),
              )
            : TaskCard(
                data: data[index - 1],
                onPressedMore: () {},
                onPressedTask: () {},
                onPressedContributors: () {},
                onPressedComments: () {},
              );
      },
      staggeredTileBuilder: (index) =>
          StaggeredTile.fit((index == 0) ? crossAxisCount : crossAxisCellCount),
    );
  }

  Widget buildActiveProject({
    required List<ProjectCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: ActiveProjectCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          itemBuilder: (context, index) {
            return ProjectCard(data: data[index]);
          },
          staggeredTileBuilder: (index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  }

  Widget buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }

  Widget buildTeamMember({required List<ImageProvider> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeamMember(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: kSpacing / 2),
          ListProfilImage(maxImages: 6, images: data),
        ],
      ),
    );
  }
}
