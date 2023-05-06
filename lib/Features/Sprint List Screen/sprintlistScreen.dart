import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import '../../Core/helper/helper.dart';
import '../../Core/routes/routes.dart';

class SprintListScreen extends StatefulWidget {
  const SprintListScreen({Key? key}) : super(key: key);

  @override
  State<SprintListScreen> createState() => _SprintListScreenState();
}

class _SprintListScreenState extends State<SprintListScreen> {
  late List<Sprints> _sprints = []; // initialize with an empty list

  @override
  void initState() {
    super.initState();
    _loadSprints();
  }

  Future<void> _loadSprints() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final sprintsRef = FirebaseFirestore.instance
        .collection('Sprints')
        .where('createdBy', isEqualTo: currentUser!.uid);
    final sprintsSnapshot = await sprintsRef.get();
    final loadedSprints = sprintsSnapshot.docs
        .map((sprints) => Sprints(
              id: sprints.id,
              createdAt: (sprints.data()["createdAt"] as Timestamp).toDate(),
              name: sprints.data()['endingDate'],
              startDate: sprints.data()['startingDate'],
              endDate: sprints.data()['endTime'],
            ))
        .toList();
    setState(() {
      _sprints = loadedSprints;
    });
  }

  Future<void> _deleteSprint(String sprintId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Sprints')
          .doc(sprintId)
          .delete();
      setState(() {
        _sprints.removeWhere((sprint) => sprint.id == sprintId);
      });
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Sprint deleted successfully',
      );
    } catch (e) {
      print('Error deleting sprint: $e');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error deleting sprint',
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement Add Sprint functionality here
          Get.toNamed(Routes.CreateSprint);
        },
        child: const Icon(Icons.add_rounded),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: size.height * 0.1,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.ProjectList);
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
            SizedBox(
              width: size.width * 0.2,
            ),
            Center(
              child: Text(
                "Sprints List",
                style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: _sprints.isEmpty
          ? FutureBuilder<void>(
              future: Future<void>.delayed(const Duration(seconds: 10)),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(
                    child: Text(
                      'Sprints cannot be created yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : ListView.builder(
              itemCount: _sprints.length,
              itemBuilder: (ctx, index) {
                final sprint = _sprints[index];
                return ListTile(
                  title: Text(
                    sprint.name,
                    style: GoogleFonts.ubuntu(
                      color: Colors.grey[800],
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Starting Date " + sprint.startDate,
                        style: GoogleFonts.ubuntu(
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Ending Date " + sprint.endDate,
                        style: GoogleFonts.ubuntu(
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'Created at: ${sprint.createdAt}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    tooltip: 'Delete Sprint',
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        text: 'Do You Want TO Delete This Sprint',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.red,
                        onConfirmBtnTap: () async {
                          await _deleteSprint(sprint.id);
                        },
                      );
                    },
                  ),
                  onTap: () {},
                );
              },
            ),
    );
  }
}

class Sprints {
  final id;
  final createdAt;
  final String name;
  final String startDate;
  final String endDate;

  Sprints({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.startDate,
    required this.endDate,
  });
}
