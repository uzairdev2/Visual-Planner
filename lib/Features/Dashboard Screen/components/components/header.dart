import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visual_planner/Features/Dashboard%20Screen/InvaitionScreen/invaitionScreen.dart';

import '../../../../Core/helper/helper.dart';
import '../shared_components/search_field.dart';
import '../shared_components/today_text.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const TodayText(),
        IconButton(
            onPressed: () {
              Get.to(InvaitionScreen());
            },
            icon: Icon(
              Icons.insert_invitation_rounded,
              size: 30,
            ))
      ],
    );
  }
}
