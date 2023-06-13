import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visual_planner/Core/common/wide_filled_button.dart';
import 'package:visual_planner/Core/routes/routes.dart';

import '../../Core/Firestore Services/firestore_services.dart';
import '../../Core/controllers/Auth Controllers/auth_controllers.dart';
import '../../Core/controllers/dashboardController.dart';
import '../../Core/helper/helper.dart';
import '../Dashboard Screen/components/components/sidebar.dart';
import '../Dashboard Screen/components/shared_components/responsive_builder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final dashboardController = DashboardController();
  String? profileImageUrl;
  String? name;
  String? email;
  String? phone;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Retriveing Data from firebasa
  Future<void> _loadUserData() async {
    final userData = await FirestoreService().getCurrentUserData();
    setState(() {
      profileImageUrl = userData.profileImageUrl;
      name = userData.name; // get user's name from Firestore
      email = userData.email; // get user's email from Firestore
      phone = userData.phone; // get user's phone from Firestore
    });
  }

  // Pick Image from Gallery
  File? pickedImage;
  bool showLocalImage = false;
  pickImageFromGallery() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    pickedImage = File(file.path);
    showLocalImage = true;

    // Upload image to Firestore Storage
    String imageUrl = await FirestoreService().uploadImage(pickedImage!);

    // Update profile image URL in Firestore database
    await FirestoreService().updateUserProfileImageUrl(imageUrl);

    setState(() {
      profileImageUrl = imageUrl;
    });
  }

  // Taking Picture with phone camera
  pickImageFromCamera() async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (file == null) return;
    pickedImage = File(file.path);
    showLocalImage = true;

    // Upload image to Firestore Storage
    String imageUrl = await FirestoreService().uploadImage(pickedImage!);

    // Update profile image URL in Firestore database
    await FirestoreService().updateUserProfileImageUrl(imageUrl);

    setState(() {
      profileImageUrl = imageUrl;
    });
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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                        width: size.width * 0.25,
                      ),
                      Center(
                        child: Text(
                          "Profile",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  if (profileImageUrl !=
                      null) // Check if profileImageUrl is not null
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(profileImageUrl!),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.mode_edit_outline_outlined,
                                ),
                                color: Colors.white,
                                onPressed: () async {
                                  // add your onPressed logic here
                                  showModelBottomSheet(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    'Name:',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (name != null)
                    Center(
                      child: Text(
                        name!,
                        style: GoogleFonts.ubuntu(
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    'Email:',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (email != null)
                    Center(
                      child: Text(
                        email!,
                        style: GoogleFonts.ubuntu(
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    'Phone:',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (phone != null)
                    Center(
                      child: Text(
                        phone!,
                        style: GoogleFonts.ubuntu(
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                  WideFilledButton(
                      btnText: 'Sign Out',
                      onTap: () async {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();


                            

                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Do you want to logout',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.red,
                          onConfirmBtnTap: () async {
                            final signOut = Provider.of<AuthController>(context,
                                listen: false);

                            await sharedPreferences.clear();
                            signOut.logout();
                            Get.offAllNamed(Routes.login);
                          },
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// To show the bottom Sheet with camera and Gallery
  Future<dynamic> showModelBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                ),
                title: Text(
                  "With Camera",
                  style: GoogleFonts.alike(
                    fontSize: 20,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
                onTap: () {
                  pickImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
              Divider(
                color: Colors.grey.shade700,
              ),
              ListTile(
                leading: const Icon(
                  Icons.storage_rounded,
                ),
                title: Text(
                  "With Gallery",
                  style: GoogleFonts.alike(
                    fontSize: 20,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
                onTap: () {
                  pickImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
