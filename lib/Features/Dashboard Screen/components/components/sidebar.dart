import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visual_planner/Core/routes/routes.dart';

import '../../../../Core/helper/helper.dart';
import '../shared_components/project_card.dart';
import '../shared_components/selection_button.dart';
import '../shared_components/upgrade_premium_card.dart';

class SIDEBAR extends StatelessWidget {
  const SIDEBAR({
    // required this.dropdownValue,
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProjectCardData data;
  //String dropdownValue = 'Workplace';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: ProjectCard(
                data: data,
              ),
            ),
            const Divider(thickness: 1),
            SelectionButton(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.grid,
                  icon: EvaIcons.gridOutline,
                  label: "Dashboard",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
                  icon: EvaIcons.calendarOutline,
                  label: "Calendar",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.list,
                  icon: EvaIcons.listOutline,
                  label: "List",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  label: "Board",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.email,
                  icon: EvaIcons.emailOutline,
                  label: "Email",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  label: "Profile",
                ),
              ],
              initialSelected: 0,
              onSelected: (index, value) {
                log("index : $index | label : ${value.label}");
                if (value.label == "Dashboard") {
                  Get.toNamed(Routes.dashboard);
                } else if (value.label == "Calendar") {
                  Get.toNamed(Routes.Calendar);
                } else if (value.label == "List") {
                  Get.toNamed(Routes.ProjectList);
                } else if (value.label == "Board") {
                  // Navigator.pushNamed(context, '/board');
                } else if (value.label == "Email") {
                  // Navigator.pushNamed(context, '/email');
                } else if (value.label == "Profile") {
                  Get.toNamed(Routes.Profile);
                }
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: kSpacing * 2),
            UpgradePremiumCard(
              backgroundColor: Theme.of(context).canvasColor.withOpacity(.4),
              onPressed: () {},
            ),
            const SizedBox(height: kSpacing),
          ],
        ),
      ),
    );
  }
}
