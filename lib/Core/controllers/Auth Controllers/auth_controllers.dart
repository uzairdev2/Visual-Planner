import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visual_planner/Core/models/Users%20Data/json_model.dart';
import 'package:visual_planner/Core/models/commonData.dart';
import 'package:visual_planner/Features/Splash%20Screen/splash_screen.dart';

import '../../common/common_snackBar.dart';
import '../../routes/routes.dart';

class AuthController with ChangeNotifier {
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  /* -----------------------------> Sign Up With Google <------------------------------ */
  Future<void> googleLogin(BuildContext context) async {
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
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      costumSnackbar("Warning", "User Google Account Not Found");
      return;
    }
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Get the user's information from the Google account
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final userProfile = userCredential.user!;
    final userName = userProfile.displayName ?? '';
    final userEmail = userProfile.email ?? '';
    final userProfileImageUrl = userProfile.photoURL ?? '';
    final userPhoneNumber = userProfile.phoneNumber ?? '';

    // Store the user's information in Firestore with the collection name "userCredential"
    await FirebaseFirestore.instance
        .collection('userCredential')
        .doc(userProfile.uid)
        .set({
      'user_id': userProfile.uid,
      'name': userName,
      'email': userEmail,
      'profileImageUrl': userProfileImageUrl,
      'phone': userPhoneNumber,
    });

    // Store the user's email in SharedPreferences
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString('email', userEmail);
    await sharedPreferences.setString('userid', userCredential.user!.uid);

    userid = sharedPreferences.getString("userid");

    // Navigate to the dashboard screen
    final data = await FirebaseFirestore.instance
        .collection('userCredential')
        .doc(userProfile.uid)
        .get();
    if (data.exists) {
      log("data fount");

      commonModel = UserModels.fromJson(data.data());

      Get.offAllNamed(Routes.dashboard);

      // log("Admin data ===> ${companyData.toJson()}");
      // log("Admin data ===> ${companyData.companyName}");
      // log("Admin data ===> ${companyData.companyUid}");
    }
    ;
    notifyListeners();
  }

/* -----------------------------> Sign Up With Email <------------------------------ */
  Future<void> SignUp(
      BuildContext context,
      TextEditingController emailController,
      userNameController,
      phoneController,
      passwordController) async {
    var name = userNameController.text.trim();
    var email = emailController.text.trim();
    var phone = phoneController.text.trim();
    var password = passwordController.text.trim();
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      // show error toast
      costumSnackbar('Warning', "Please fill all the fields");
      return;
    }

    if (!emailRegExp.hasMatch(email)) {
      costumSnackbar('Warning', "Please enter a valid email address");
      return;
    }

    if (password.length < 8) {
      // show password weakness error toast
      costumSnackbar('Password Error', 'Weak Password Make it Strong');
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
    // request to firebase auth
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      commonModel.email = emailController.text;
      commonModel.name = userNameController.text;
      commonModel.phone = phoneController.text;
      commonModel.profileImageUrl =
          'https://firebasestorage.googleapis.com/v0/b/virtual-planner-22a5c.appspot.com/o/profile_images%2Fuser%20(4).png?alt=media&token=344b3015-a9a9-4d7e-ba0e-345069e9e28f';
      commonModel.userid = userCredential.user!.uid;
      FirebaseFirestore.instance
          .collection('userCredential')
          .doc(userCredential.user!.uid)
          .set(commonModel.toJson());

      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('email', email);
      await sharedPreferences.setString('userid', userCredential.user!.uid);

      userid = sharedPreferences.getString("userid");
      log("here is google  $userid");

      final data = await FirebaseFirestore.instance
          .collection('userCredential')
          .doc(userCredential.user!.uid)
          .get();
      if (data.exists) {
        log("data fount");

        commonModel = UserModels.fromJson(data.data());

        log("Admin data ===> ${commonModel.userid}");
        // log("Admin data ===> ${companyData.companyName}");
        // log("Admin data ===> ${companyData.companyUid}");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Navigator.of(context).pop();
        costumSnackbar("Email Error", "Email is already in use");

        return;
      } else if (e.code == 'weak-password') {
        Navigator.of(context).pop();
        costumSnackbar("Wrong Password", "weak password make it strong");

        return;
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        titleColor: Colors.white,
        backgroundColor: Colors.grey.shade700,
        textColor: Colors.white,
      );
      return;
    }

    Get.offAllNamed(Routes.dashboard);

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Successfully Rigesterd",
      backgroundColor: Colors.grey.shade700,
      titleColor: Colors.white,
    );
  }

  /* -----------------------------> Sign In With Email <------------------------------ */
  Future<void> SignIn(BuildContext context,
      TextEditingController emailController, passwordController) async {
    var email = emailController.text.trim();
    var password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // show error toast
      costumSnackbar('Empty Fields', "Please Enter Email and Password");
      return;
    }
    if (!emailRegExp.hasMatch(email)) {
      costumSnackbar('Warning', "Please enter a valid email address");
      return;
    }
    if (password.length < 8) {
      // show error toast
      costumSnackbar('Password', 'Please Enter The Correct Password');
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

    // request to firebase auth
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        Navigator.of(context).pop();

        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('email', email);
        await sharedPreferences.setString('userid', userCredential.user!.uid);

        userid = sharedPreferences.getString("userid");
        log("here is login id $userid");

        var data = await FirebaseFirestore.instance
            .collection('userCredential')
            .doc(userCredential.user!.uid)
            .get();
        if (data.exists) {
          log("data found");

          commonModel = UserModels.fromJson(data.data());

          Get.offAllNamed(Routes.dashboard);
        }
      } else {
        costumSnackbar("Some Error", "User Not Found");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      if (e.code == 'user-not-found') {
        costumSnackbar("Some Error", "User Not Found");

        return;
      } else if (e.code == 'wrong-password') {
        costumSnackbar("Wrong Password", "Make Sure Password is correct");

        return;
      }
    } catch (e) {
      Navigator.of(context).pop();
      costumSnackbar("Erorr Found", "Something went wrong");

      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Successfully Login",
      backgroundColor: Colors.grey.shade700,
      titleColor: Colors.white,
    );
  }

/* -----------------------------> Forgot Password <------------------------------ */
  Future<void> resetPassword(
    BuildContext context,
    TextEditingController emailController,
  ) async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      // show error toast
      costumSnackbar('Warning', "Please fill the field");
      return;
    }
    if (!emailRegExp.hasMatch(email)) {
      costumSnackbar('Warning', "Please enter a valid email address");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message or navigate to success screen
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Email Was Send",
        backgroundColor: Colors.grey.shade700,
        titleColor: Colors.white,
        onConfirmBtnTap: () {
          Get.toNamed(Routes.login);
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      // Show error message or handle the error
      costumSnackbar('Wrong Email', "there is no User record with this email");
    }
  }

  /* -----------------------------> Logout <------------------------------ */

  Future<void> logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove('email');
  }
}
