import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/TaskScreen/TaskScreen.dart';

import '../../Core/controllers/dashboardController.dart';
import '../../Core/helper/helper.dart';
import '../../Core/models/commonData.dart';
import '../Dashboard Screen/SprintScreen/sprint.dart';
import '../Dashboard Screen/TaskScreen/taskshowModel.dart';
import '../Dashboard Screen/components/components/active_project_card.dart';
import '../Dashboard Screen/components/components/overview_header.dart';
import '../Dashboard Screen/components/components/recent_messages.dart';
import '../Dashboard Screen/components/components/team_member.dart';
import '../Dashboard Screen/components/shared_components/chatting_card.dart';
import '../Dashboard Screen/components/shared_components/project_card.dart';
import '../Dashboard Screen/components/shared_components/task_card.dart';
import '../Splash Screen/splash_screen.dart';

// ignore: must_be_immutable
class SprintDetailsScreen extends StatefulWidget {
  SprintDetailsScreen({required this.data, super.key});
  dynamic data;

  @override
  State<SprintDetailsScreen> createState() => _SprintDetailsScreenState();
}

final dashboardController = DashboardController();

class _SprintDetailsScreenState extends State<SprintDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: dashboardController.scafolKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(
            ScreenName: "Tasks Details",
            // customwidget: Padding(
            //   padding: EdgeInsets.only(left: Get.width / 7),
            //   child: IconButton(icon: Icon(Icons.add), onPressed: () {}),
            // ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Card(
                color: Colors.amber[100],
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Task',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Invitations")
                              .where(
                                "sprintName",
                                isEqualTo: widget.data["sprintName"],
                              )
                              .where("status", isEqualTo: "Accepted")
                              .get()
                              .then((value) {
                            if (value.docs.length > 0) {
                              List member = [];
                              for (var i = 0; i < value.docs.length; i++) {
                                member.add(value.docs[i]["recipientEmails"]);
                              }

                              log("here is the member $member");

                              // var data = value.docs[].data();
                              Get.to(TaskScreen(
                                member: member,
                                data: widget.data,
                              ));
                            } else {
                              Get.snackbar("Error",
                                  "No Member Accept Invaition in this Sprint");
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Invitations")
                    .where(
                      "sprintName",
                      isEqualTo: widget.data["sprintName"],
                    )
                    .where("status", isEqualTo: "Accepted")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text(
                      "No member",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];

                          taskModel activetask = taskModel
                              .fromJson(snapshot.data!.docs[index].data());

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TeamMember(
                                totalMember: snapshot.data!.docs.length,
                                onPressedAdd: () {},
                              ),
                              const SizedBox(height: kSpacing / 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    alignment: Alignment.centerRight,
                                    children: _getLimitImage(
                                            dashboardController.getMember(),
                                            snapshot.data!.docs.length)
                                        .asMap()
                                        .entries
                                        .map(
                                          (e) => Padding(
                                            padding: EdgeInsets.only(
                                                right: (e.key * 25.0)),
                                            child: _image(
                                              e.value,
                                              onPressed: () {},
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        TextEditingController emailcotroller =
                                            TextEditingController();
                                        Get.defaultDialog(
                                          title: "Add Member",
                                          content: Column(
                                            children: [
                                              TextFormField(
                                                controller: emailcotroller,
                                                decoration: InputDecoration(
                                                  hintText: "Enter Email",
                                                ),
                                              ),
                                            ],
                                          ),
                                          onCancel: () {},
                                          onConfirm: () {
                                            if (emailcotroller.text == "") {
                                              Get.snackbar("Empty Email",
                                                  "Please enter email");
                                              return;
                                            } else {
                                              FirebaseFirestore.instance
                                                  .collection('Invitations')
                                                  .add({
                                                'sprintName':
                                                    widget.data["sprintName"],
                                                'startingDate':
                                                    widget.data["startingDate"],
                                                'endingDate':
                                                    widget.data["endingDate"],
                                                'senderEmail':
                                                    commonModel.email,
                                                'recipientEmails': emailcotroller
                                                    .text
                                                    .trim(), // Create an empty object to store the recipients and their status
                                                "status": "Pending",
                                              });
                                              Get.back();
                                              Get.snackbar("email",
                                                  "email added successfully ");
                                            }
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.add))
                                ],
                              )
                            ],
                          );
                        });
                  }
                },
              ),

              fixheight,

              const SizedBox(height: kSpacing),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Tasks')
                    .where('taskProjectId', isEqualTo: widget.data["projectId"])
                    .where('taskSprint', isEqualTo: widget.data["sprintName"])
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Center(
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
                              // Get.to(ShowAddedTask(
                              //     Sprintid: data["projectId"],
                              //     Sprintname: data["sprintName"]));
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
                                        subtitle:
                                            "assigned from  ${activetask.taskProjectManager}",
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
                                                      child: const Text(
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
                                                      child: const Text(
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
                                                      child: const Text(
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    // task priority
                                                     Get.defaultDialog(
                                                title: "Task Priority",
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
                
                                                          'taskStatusColor2':
                                                              'red'
                                                        });
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                        "High Priority",
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
                                                          
                                                          'taskStatusColor2':
                                                              'yellow'
                                                        });
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                        "Medium Priority",
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
                                                       
                                                          'taskStatusColor2':
                                                              'green'
                                                        });
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                        "Low Priority",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onCancel: () {
                                                
                                                },
                                              );
                                                  },
                                                  icon: Icon(Icons.flag, color: activetask.taskStatusColor2 == "red"?Colors.red : activetask.taskStatusColor2 == "yellow"?Colors.amber:Colors.green,)),
                                              activetask.taskStatus ==
                                                      "Complete"
                                                  ? IconButton(
                                                      onPressed: () {
                                                        Get.defaultDialog(
                                                            title:
                                                                "Delete ticket",
                                                            content: const Text(
                                                                "Are you sure you want to delete this ticket?"),
                                                            onCancel: () {
                                                              // Get.back();
                                                            },
                                                            onConfirm: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Tasks')
                                                                  .doc(data.id)
                                                                  .delete();
                                                            });
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 30,
                                                      ))
                                                  : SizedBox.shrink(),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: kSpacing / 2),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kSpacing / 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButtons(
                                            iconData:
                                                EvaIcons.messageCircleOutline,
                                            onPressed: () {
                                              TextEditingController
                                                  commentController =
                                                  TextEditingController();
                                              Get.bottomSheet(Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
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
                                                                return const Center(
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
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            decoration: const BoxDecoration(
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
                                                                        icon: const Icon(
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
                                                                          commentController
                                                                              .clear();
                                                                        },
                                                                      )),
                                                            ),
                                                          )),
                                                    ],
                                                  )));
                                            },
                                          ),
                                          const SizedBox(width: kSpacing / 2),
                                          SizedBox(
                                            width: 100,
                                            height: 30,
                                            child: ListView.builder(
                                                // shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: activetask
                                                    .taskMember!.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      // Tooltip(
                                                      //   message: activetask.taskMember![index][0],
                                                      //   child: Text(activetask.taskMember![index][0]),
                                                      // );
                                                    },
                                                    child: Tooltip(
                                                      message: activetask
                                                          .taskMember![index],
                                                      child: CircleAvatar(
                                                        child: Text(activetask
                                                                .taskMember![
                                                            index][0]),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
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
              // buildActiveProject(
              //   data: dashboardController.getActiveProject(),
              //   crossAxisCount: 6,
              //   crossAxisCellCount: 6,
              // ),
              // const SizedBox(height: kSpacing),
              // buildRecentMessages(data: dashboardController.getChatting()),
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
    Axis headerAxis = Axis.horizontal,
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
                  axis: headerAxis,
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
          Stack(
            alignment: Alignment.centerRight,
            children: _getLimitImage(data, 6)
                .asMap()
                .entries
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.only(right: (e.key * 25.0)),
                    child: _image(
                      e.value,
                      onPressed: () {},
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

List<ImageProvider> _getLimitImage(List<ImageProvider> images, int limit) {
  if (images.length <= limit) {
    return images;
  } else {
    List<ImageProvider> result = [];
    for (int i = 0; i < limit; i++) {
      result.add(images[i]);
    }
    return result;
  }
}

Widget _image(ImageProvider image, {Function()? onPressed}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(Get.context!).cardColor,
      ),
      child: CircleAvatar(
        backgroundImage: image,
        radius: 15,
      ),
    ),
  );
}
