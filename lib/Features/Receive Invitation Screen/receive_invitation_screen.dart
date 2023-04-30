import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Core/controllers/dashboardController.dart';
import '../../Core/helper/helper.dart';
import '../Dashboard Screen/components/components/sidebar.dart';
import '../Dashboard Screen/components/shared_components/responsive_builder.dart';

class ReceiveInvitationScreen extends StatefulWidget {
  const ReceiveInvitationScreen({Key? key}) : super(key: key);

  @override
  _ReceiveInvitationScreenState createState() =>
      _ReceiveInvitationScreenState();
}

class _ReceiveInvitationScreenState extends State<ReceiveInvitationScreen> {
  late Stream<QuerySnapshot> _invitationStream;
  final dashboardController = DashboardController();

  @override
  void initState() {
    super.initState();
    _loadSprintData();
  }

  void _loadSprintData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserEmail = currentUser?.email;
    _invitationStream = FirebaseFirestore.instance
        .collection('Invitations')
        .where('recipientEmails', arrayContains: currentUserEmail)
        .where('senderEmail', isNotEqualTo: currentUserEmail)
        .snapshots();
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
                "Invitations",
                style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _invitationStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No invitations found'));
          }

          final invitationDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: invitationDocs.length,
            itemBuilder: (context, index) {
              final invitationData =
                  invitationDocs[index].data() as Map<String, dynamic>;
              final sprintName = invitationData['sprintName'] as String;
              final startingDate = invitationData['startingDate'] as String;
              final endingDate = invitationData['endingDate'] as String;
              final senderEmail = invitationData['senderEmail'] as String;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sprint name: $sprintName",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Start: $startingDate",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "End: $endingDate",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sent by: $senderEmail",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // code for accepting invitation
                                final invitationDocId =
                                    invitationDocs[index].id;
                                await FirebaseFirestore.instance
                                    .collection('Invitations')
                                    .doc(invitationDocId)
                                    .update({'status': 'Accepted'});
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                // code for rejecting invitation
                                final invitationDocId =
                                    invitationDocs[index].id;
                                await FirebaseFirestore.instance
                                    .collection('Invitations')
                                    .doc(invitationDocId)
                                    .update({'status': 'Rejeted'});
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
