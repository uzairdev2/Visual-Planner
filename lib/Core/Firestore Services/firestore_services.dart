import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../common/common_snackBar.dart';
import '../models/Users Data/json_model.dart';
import '../routes/routes.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Getting All user data from Firestore database
  Future<List<Users>> getAllUsersData() async {
    final users = <Users>[];
    final snapshot = await _db.collection('userCredential').get();

    for (final doc in snapshot.docs) {
      final user = Users.fromJson(doc.data());
      users.add(user);
    }

    return users;
  }

// Just Getting Current user data from firestore
  Future<Users> getCurrentUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final doc =
        await _db.collection('userCredential').doc(currentUser!.uid).get();
    final user = Users.fromJson(doc.data()!);
    return user;
  }

  // Uploading the Picture to firebase storage then retriveing
  Future<String> uploadImage(File file) async {
    final storage = FirebaseStorage.instance;
    final ref =
        storage.ref().child('profile_images/${DateTime.now().toString()}');
    final task = ref.putFile(file);

    final snapshot = await task.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();

    return url;
  }

  // When user upload image to firebase storage then we will update user profile imag
  // retrive from firebase firestore
  Future<void> updateUserProfileImageUrl(String profileImageUrl) async {
    final userId = _auth.currentUser!.uid;
    final userDocRef = _firestore.collection('userCredential').doc(userId);
    await userDocRef.update({'profileImageUrl': profileImageUrl});
  }

/* -----------------------------> Upload Project details <------------------------------ */

  Future<void> uploadProjectData(
    BuildContext context,
    TextEditingController projectNameController,
    TextEditingController descriptionController,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user1 = auth.currentUser;
    // Get the values from the text fields
    var projectName = projectNameController.text.trim();
    var description = descriptionController.text.trim();

    if (projectName.isEmpty || description.isEmpty) {
      // show error toast
      costumSnackbar(
          'Empty Fields', "Please Enter Project Name and Description");
      return;
    }

    // Get the current user's ID and name
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String userName = FirebaseAuth.instance.currentUser!.displayName ?? '';

    // Create a reference to the "Projects" collection in Firestore
    CollectionReference projectsCollection =
        FirebaseFirestore.instance.collection('Projects');

    // Check if the user already has a project
    QuerySnapshot querySnapshot = await projectsCollection
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get(); // limit to 1 project
    if (querySnapshot.size > 0) {
      // user already has a project, show message and return
      costumSnackbar('Cannot Create Project',
          'You have already created a project. You cannot create another project.');
      return;
    }

    //Progress bar
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading .....',
      titleColor: Colors.white,
      backgroundColor: Colors.grey.shade700,
      text: 'Fetching Your Data',
      textColor: Colors.white,
    );

    // Add a new document to the "Projects" collection with an auto-generated ID
    DocumentReference projectDocument = projectsCollection.doc();
    final newProjectId = projectDocument.id;

    // Set the data for the document
    await projectDocument.set({
      'projectId': newProjectId,
      'projectName': projectName,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': userId,
      'userName': userName
    });

    Get.toNamed(Routes.ProjectList);
  }

  /* -----------------------------> Upload Sprint details <------------------------------ */

  Future<void> uploadSprintData(
    BuildContext context,
    TextEditingController sprintNameController,
    startTimeController,
    endTimeController,
  ) async {
    var sprintName = sprintNameController.text.trim();
    var startTime = startTimeController.text.trim();
    var endTime = endTimeController.text.trim();
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If there is no logged in user, display an error message
      Get.snackbar('Error', 'You need to log in first!');
      return;
    }

    // Check the textfields are empty or not
    if (sprintName.isEmpty) {
      // show error toast
      costumSnackbar('Empty Fields',
          "Please Enter Sprint Name, start Time, and End Time ");
      return;
    }
    //Progress bar
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading .....',
      titleColor: Colors.white,
      backgroundColor: Colors.grey.shade700,
      text: 'Fetching Your Data',
      textColor: Colors.white,
    );

    // Retrieve the project ID and name from the user's data in Firestore
    QuerySnapshot<Map<String, dynamic>> projectsSnapshot =
        await FirebaseFirestore.instance
            .collection('Projects')
            .where('userId', isEqualTo: user.uid)
            .get();
    if (projectsSnapshot.docs.isEmpty) {
      // If there is no project found for the user, display an error message
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        titleColor: Colors.white,
        backgroundColor: Colors.red.shade700,
        text: 'You need to create a project first!',
        textColor: Colors.white,
      );
      return;
    }
// Assuming that you only have one project per user, get the first document
    DocumentSnapshot<Map<String, dynamic>> projectSnapshot =
        projectsSnapshot.docs.first;
    String projectId = projectSnapshot.id;
    String projectName = projectSnapshot.data()!['projectName'];

    // Add the Sprint collection to the Firestore
    DocumentReference sprintDocRef =
        await FirebaseFirestore.instance.collection('Sprints').add({
      'sprintName': sprintName,
      'startTime': startTime,
      'endTime': endTime,
      'projectId': projectId,
      'projectName': projectName,
      'createdBy': user.uid,
      'createdByName': user.displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
    String sprintId = sprintDocRef.id;

// Update the sprint document with the sprint id
    await sprintDocRef.update({
      'sprintId': sprintId,
    });
  }

/* -----------------------------> Check Sprints Collection Exists <------------------------------ */
  Future<void> checkSprintsCollectionExists() async {
    final User? user = FirebaseAuth.instance.currentUser;

    final sprintsQuerySnapshot = await FirebaseFirestore.instance
        .collection('Sprints')
        .where('createdBy', isEqualTo: user?.uid)
        .limit(1)
        .get();

    if (sprintsQuerySnapshot.docs.isNotEmpty) {
      // Sprints collection exists, show Sprint List Screen
      Get.toNamed(Routes.SprintList);
    } else {
      // Sprints collection doesn't exist, show Create Sprint Screen
      Get.toNamed(Routes.CreateSprint);
    }
  }

  Future<void> createInvitation(Map<String, dynamic> invitationData) async {
    final invitationsCollection = _firestore.collection('Invitations');
    await invitationsCollection.add(invitationData);
  }
}
