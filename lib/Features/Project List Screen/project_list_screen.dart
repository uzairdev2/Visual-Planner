import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import '../../Core/Firestore Services/firestore_services.dart';
import '../../Core/controllers/dashboardController.dart';
import '../../Core/helper/helper.dart';
import '../../Core/routes/routes.dart';
import '../Dashboard Screen/components/components/sidebar.dart';
import '../Dashboard Screen/components/shared_components/responsive_builder.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final dashboardController = DashboardController();
  FirestoreService _service = FirestoreService();
  late List<Project> _projects = []; // initialize with an empty list

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final projectsRef = FirebaseFirestore.instance
        .collection('Projects')
        .where('userId', isEqualTo: currentUser!.uid);
    final projectsSnapshot = await projectsRef.get();
    final loadedProjects = projectsSnapshot.docs
        .map((project) => Project(
              id: project.id,
              createdAt: (project.data()["createdAt"] as Timestamp).toDate(),
              name: project.data()['projectName'],
              description: project.data()['description'],
            ))
        .toList();
    setState(() {
      _projects = loadedProjects;
    });
  }

  Future<void> _deleteProject(String projectId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final projectsRef = FirebaseFirestore.instance.collection('Projects');
      final projectRef = projectsRef.doc(projectId);
      final userProjectsRef =
          projectsRef.where('userId', isEqualTo: currentUser!.uid);
      await projectRef.delete();

      setState(() {
        _projects.removeWhere((project) => project.id == projectId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete project!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: dashboardController.scafolKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: SIDEBAR(
                  data: dashboardController.getSelectedProject(),
                ),
              ),
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
                dashboardController.openDrawer();
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(237, 244, 243, 1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.menu,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.2,
            ),
            Center(
              child: Text(
                "Projects List",
                style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: _projects.isEmpty
          ? FutureBuilder<void>(
              future: Future<void>.delayed(const Duration(seconds: 10)),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                      child: TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.addProject);
                    },
                    child: const Text(
                      'Projects cannot be created yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : ListView.builder(
              itemCount: _projects.length,
              itemBuilder: (ctx, index) {
                final project = _projects[index];
                return ListTile(
                  title: Text(
                    project.name,
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
                        "\t\t\t\t" + project.description,
                        style: GoogleFonts.ubuntu(
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'Created at: ${project.createdAt}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    tooltip: 'Delete Project',
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        text: 'Do You Want TO Delete This Project',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.red,
                        onConfirmBtnTap: () async {
                          _deleteProject(
                              project.id); // pass the project id here
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  onTap: () {
                    _service.checkSprintsCollectionExists();
                  },
                );
              },
            ),
    );
  }
}

class Project {
  final id;
  final createdAt;
  final String name;
  final String description;

  Project({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.description,
  });
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size size;

  const CustomAppBar({Key? key, required this.size}) : super(key: key);

  @override
  Size get preferredSize => size;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        // Your custom app bar implementation here
        );
  }
}
