import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:visual_planner/Core/models/commonData.dart';

import '../../Core/Firestore Services/firestore_services.dart';
import '../../Core/helper/helper.dart';
import '../../Core/models/Users Data/json_model.dart';
import '../../Core/routes/routes.dart';
import '../Add Sprint Screen/add_sprint_screen.dart';

class SendInvitationScreen extends StatefulWidget {
  final SprintData sprintData;

  const SendInvitationScreen({
    required this.sprintData,
    super.key,
  });

  @override
  State<SendInvitationScreen> createState() => _SendInvitationScreenState();
}

class _SendInvitationScreenState extends State<SendInvitationScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserModels> _users = [];
  // ignore: prefer_final_fields
  List<UserModels> _selectedUsers = [];
  Users? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchCurrentUser();
  }

  Future<void> _fetchUsers() async {
    final users = await _firestoreService.getAllUsersData();
    setState(() {
      _users = users;
    });
  }

  Future<void> _fetchCurrentUser() async {
    final currentUser = await _firestoreService.getCurrentUserData();
    setState(() {
      _currentUser = currentUser;
    });
  }

  bool _isSelected(UserModels user) {
    return _selectedUsers.contains(user);
  }

  void _toggleSelection(UserModels user) {
    setState(() {
      if (_isSelected(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  bool _isCurrentUser(UserModels user) {
    return _currentUser != null && user.email == _currentUser?.email;
  }

  Future<void> _uploadInvitationData() async {
    final currentUserEmail = _currentUser?.email;
    final selectedUserEmails =
        _selectedUsers.map((user) => user.email).toList();

    // Create an object to store the invitation data and recipient emails and their status
    // final invitationData = {
    //   'sprintName': widget.sprintData.sprintName,
    //   'startingDate': widget.sprintData.startingDate,
    //   'endingDate': widget.sprintData.endingDate,
    //   'senderEmail': currentUserEmail,
    //   'recipientEmails': <String,
    //       String>{}, // Create an empty object to store the recipients and their status
    // };

    // Add the recipient emails to the invitation data object with 'Pending' status
    // for (final recipientEmail in selectedUserEmails) {
    //   (invitationData['recipientEmails']
    //       as Map<String, String>)[recipientEmail] = 'Pending';
    // }

    final invitationsCollection =
        FirebaseFirestore.instance.collection('Invitations');

    for (int i = 0; i < selectedUserEmails.length; i++) {
      // ignore: unused_local_variable
      final invitationDocRef = await invitationsCollection.add(
        {
          'sprintName': widget.sprintData.sprintName,
          'startingDate': widget.sprintData.startingDate,
          'endingDate': widget.sprintData.endingDate,
          'senderEmail': currentUserEmail,
          'recipientEmails': selectedUserEmails[
              i], // Create an empty object to store the recipients and their status
          "status": "Pending",
        },
      );

      // (invitationData['recipientEmails']
      //     as Map<String, dynamic>)[i.toString()] = selectedUserEmails[i];
      // (invitationData['recipientEmails']
      //     as Map<String, dynamic>)[i.toString()] = "Pending";
      //     {
      //   selectedUserEmails[i],
      //   // "Pending",
      // };
    }

    //   (invitationData['recipientEmails'] as Map<String, String>)["Status"] =
    //       "Pending";
    // }

    // Create the Invitations collection and add the invitation data

    // Show success message and navigate to the SprintList page
    Get.offAllNamed(Routes.dashboard);
    // ignore: use_build_context_synchronously
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Invitation Was Sent",
      backgroundColor: Colors.grey.shade700,
      titleColor: Colors.white,
    );
  }

  /* -----------------------------> Upload Sprint details <------------------------------ */

  Future<void> uploadSprintData() async {
    String sprintName = widget.sprintData.sprintName;
    String startingDate = widget.sprintData.startingDate;
    String endingDate = widget.sprintData.endingDate;
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If there is no logged in user, display an error message
      Get.snackbar('Error', 'You need to log in first!');
      return;
    }

    // Retrieve the project ID and name from the user's data in Firestore
    QuerySnapshot<Map<String, dynamic>> projectsSnapshot =
        await FirebaseFirestore.instance
            .collection('Projects')
            .where('userId', isEqualTo: user.uid)
            .get();
    if (projectsSnapshot.docs.isEmpty) {
      // If there is no project found for the user, display an error message
      // ignore: use_build_context_synchronously
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
    // ignore: unused_local_variable
    DocumentReference sprintDocRef =
        await FirebaseFirestore.instance.collection('Sprints').add({
      'sprintName': sprintName,
      'startingDate': startingDate,
      'endingDate': endingDate,
      'projectId': projectId,
      'projectName': projectName,
      'createdById': user.uid,
      'createdByName': commonModel.name.toString(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              width: size.width * 0.1,
            ),
            Text(
              "Invite Members",
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          log("her is user nanem ${_users[index]}");
          if (_isCurrentUser(user)) {
            return const SizedBox.shrink(); // don't show current user in list
          }
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl!),
            ),
            title: Text(user.name!),
            subtitle: Text(user.email!),
            trailing: Checkbox(
              value: _isSelected(user),
              onChanged: (value) => _toggleSelection(user),
            ),
          );
        },
      ),
      floatingActionButton: _selectedUsers.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.loading,
                  title: 'Loading',
                  text: 'Please Wait Patiently',
                );
                // Uploading the sprint details to the firestore database
                await uploadSprintData();

                // Implement invite functionality here
                await _uploadInvitationData();
              },
              child: const Icon(Icons.send),
            )
          : null,
    );
  }
}
