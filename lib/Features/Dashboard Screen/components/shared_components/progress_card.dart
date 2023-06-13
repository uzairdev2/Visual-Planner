import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visual_planner/Core/models/commonData.dart';
import 'package:visual_planner/Features/Splash%20Screen/splash_screen.dart';

import '../../../../Core/helper/helper.dart';
import '../../../Project List Screen/project_list_screen.dart';

class ProgressCardData {
  final int totalUndone;
  final int totalTaskInProress;

  const ProgressCardData({
    required this.totalUndone,
    required this.totalTaskInProress,
  });
}

class ProgressCard extends StatefulWidget {
  const ProgressCard({
    required this.data,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);
  final ProgressCardData data;
  final Function() onPressedCheck;

  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  late Project _project = Project(
    id: '',
    createdAt: DateTime.now(),
    name: 'Project Not\n created yet',
    description: '',
  );

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    // final currentUser = FirebaseAuth.instance.currentUser;
    final projectsRef = FirebaseFirestore.instance
        .collection('Projects')
        .where('userId', isEqualTo: userid);
    final projectsSnapshot = await projectsRef.get();
    final loadedProjects = projectsSnapshot.docs
        .map((project) => Project(
              id: project.id,
              createdAt: (project.data()["createdAt"] as Timestamp).toDate(),
              name: project.data()['projectName'],
              description: project.data()['description'],
            ))
        .toList();
    if (loadedProjects.isNotEmpty) {
      setState(() {
        _project = loadedProjects.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectName = _project.name;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(10, 30),
                child: const SizedBox(
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage("assets/images/happy-2.png"),
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
                  projectName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
                Text(
                  "Working on a new track...",
                  style: TextStyle(color: kFontColorPallets[1]),
                ),
                const SizedBox(height: kSpacing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
