import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visual_planner/Core/routes/assets_paths.dart';

import '../../../../Core/helper/helper.dart';

class ProgressCardData {
  final int totalUndone;
  final int totalTaskInProress;

  const ProgressCardData({
    required this.totalUndone,
    required this.totalTaskInProress,
  });
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.data,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);

  final ProgressCardData data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(10, 30),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage("assets/images/happy-2.png"),
                    fit: BoxFit.fitHeight,
                  ),
                  // child: SvgPicture.asset(
                  //   ImageVectorPath.happy2,
                  //   fit: BoxFit.fitHeight,
                  // ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: kSpacing,
              top: kSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Syabany Labs",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 30),
                ),
                Text(
                  "Working on a new track...",
                  style: TextStyle(color: kFontColorPallets[1]),
                ),
                const SizedBox(height: kSpacing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
