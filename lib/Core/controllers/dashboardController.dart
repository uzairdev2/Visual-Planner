// import 'package:flutter/cupertino.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:visual_planner/modules/dashboard/Components/projectCard.dart';

// class DashboardController extends GetxController {
//   // Data
//   ProjectCardData getSelectedProject() {
//     return ProjectCardData(
//       percent: .3,
//       projectImage: const AssetImage("assets/images/user.png"),
//       projectName: "Visual Planner",
//       releaseTime: DateTime.now(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Features/Dashboard Screen/components/shared_components/chatting_card.dart';
import '../../Features/Dashboard Screen/components/shared_components/project_card.dart';
import '../../Features/Dashboard Screen/components/shared_components/task_card.dart';
import '../helper/taskType.dart';
import '../models/profile.dart';

class DashboardController extends GetxController {
  final scafolKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    if (scafolKey.currentState != null) {
      scafolKey.currentState!.openDrawer();
    }
  }

  // Data
  Profile getProfil() {
    return const Profile(
      photo: AssetImage("assets/images/user.png"),
      name: "Hammad",
      email: "HammadAli@gmail.com",
    );
  }

  List<TaskCardData> getAllTask() {
    return [
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: 2,
        totalComments: 50,
        type: TaskType.todo,
        totalContributors: 30,
        profilContributors: [
          AssetImage("assets/images/user.png"),
          AssetImage("assets/images/user (1).png"),
          AssetImage("assets/images/user (2).png"),
          AssetImage("assets/images/user (3).png"),
        ],
      ),
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          AssetImage("assets/images/user.png"),
          AssetImage("assets/images/user (2).png"),
          AssetImage("assets/images/user (3).png"),
          AssetImage("assets/images/user (4).png"),
        ],
      ),
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.done,
        profilContributors: [
          AssetImage("assets/images/user (3).png"),
          AssetImage("assets/images/user (4).png"),
          AssetImage("assets/images/user (2).png"),
          AssetImage("assets/images/user (1).png"),
        ],
      ),
    ];
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage("assets/images/user.png"),
      projectName: "Task Planner",
      releaseTime: DateTime.now(),
    );
  }

  List<ProjectCardData> getActiveProject() {
    return [
      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage("assets/images/user.png"),
        projectName: "ToDO",
        releaseTime: DateTime.now().add(const Duration(days: 130)),
      ),
      ProjectCardData(
        percent: .5,
        projectImage: const AssetImage("assets/images/user.png"),
        projectName: "In Progress",
        releaseTime: DateTime.now().add(const Duration(days: 140)),
      ),
      ProjectCardData(
        percent: .8,
        projectImage: const AssetImage("assets/images/user.png"),
        projectName: "Done",
        releaseTime: DateTime.now().add(const Duration(days: 100)),
      ),
    ];
  }

  List<ImageProvider> getMember() {
    return const [
      AssetImage("assets/images/user (1).png"),
      AssetImage("assets/images/user (2).png"),
      AssetImage("assets/images/user (3).png"),
      AssetImage("assets/images/user (4).png"),
      AssetImage("assets/images/user.png"),
      AssetImage("assets/images/user (1).png"),
    ];
  }

  List<ChattingCardData> getChatting() {
    return const [
      ChattingCardData(
        image: AssetImage("assets/images/user (4).png"),
        isOnline: true,
        name: "Hassan",
        lastMessage: "i added my new tasks",
        isRead: false,
        totalUnread: 100,
      ),
      ChattingCardData(
        image: AssetImage("assets/images/user (3).png"),
        isOnline: false,
        name: "Hammad",
        lastMessage: "well done Hassan",
        isRead: true,
        totalUnread: 0,
      ),
      ChattingCardData(
        image: AssetImage("assets/images/user (2).png"),
        isOnline: true,
        name: "Noor",
        lastMessage: "we'll have a meeting at 9AM",
        isRead: false,
        totalUnread: 1,
      ),
    ];
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }
}
