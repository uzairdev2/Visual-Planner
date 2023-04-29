import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import '../../Core/Firestore Services/firestore_services.dart';
import '../../Core/helper/helper.dart';
import '../../Core/models/Users Data/json_model.dart';
import '../../Core/routes/routes.dart';

class SendInvitationScreen extends StatefulWidget {
  final String sprintName;
  final String startingDate;
  final String endingDate;
  const SendInvitationScreen({
    required this.sprintName,
    required this.startingDate,
    required this.endingDate,
    super.key,
  });

  @override
  State<SendInvitationScreen> createState() => _SendInvitationScreenState();
}

class _SendInvitationScreenState extends State<SendInvitationScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Users> _users = [];
  List<Users> _selectedUsers = [];
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

  bool _isSelected(Users user) {
    return _selectedUsers.contains(user);
  }

  void _toggleSelection(Users user) {
    setState(() {
      if (_isSelected(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  bool _isCurrentUser(Users user) {
    return _currentUser != null && user.email == _currentUser?.email;
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
              "Invite Your Friends",
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
          if (_isCurrentUser(user)) {
            return const SizedBox.shrink(); // don't show current user in list
          }
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
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
                // Implement invite functionality here
                final currentUserEmail = _currentUser?.email;
                final selectedUserEmails =
                    _selectedUsers.map((user) => user.email).toList();
                final invitationData = {
                  'sprintName': widget.sprintName,
                  'startingDate': widget.startingDate,
                  'endingDate': widget.endingDate,
                  'senderEmail': currentUserEmail,
                  'recipientEmails': selectedUserEmails,
                };
                await _firestoreService.createInvitation(invitationData);
                Get.toNamed(Routes.SprintList);
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: "Invitation Was Sent",
                  backgroundColor: Colors.grey.shade700,
                  titleColor: Colors.white,
                );
              },
              child: const Icon(Icons.send),
            )
          : null,
    );
  }
}
