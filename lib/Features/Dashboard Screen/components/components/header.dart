import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visual_planner/Core/routes/routes.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/InvaitionScreen/invitionScreen.dart';

import '../shared_components/today_text.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const TodayText(),
        Tooltip(
          message: 'Invitations',
          textStyle: TextStyle(
            color: Colors.black,
          ),
          child: IconButton(
              tooltip: 'Invitations',
              onPressed: () {
                Get.toNamed(Routes.ReceiveInvitation);
              },
              icon: const Icon(
                Icons.email_outlined,
              )),
        ),
      ],
    );
  }
}
