import 'package:flutter/material.dart';

import '../../../../Core/helper/helper.dart';

class TeamMember extends StatelessWidget {
  const TeamMember({
    required this.totalMember,
    required this.onPressedAdd,
    Key? key,
  }) : super(key: key);

  final int totalMember;
  final Function() onPressedAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kFontColorPallets[0],
            ),
            children: [
              const TextSpan(text: "Team Member "),
              TextSpan(
                text: "($totalMember)",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: kFontColorPallets[2],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
