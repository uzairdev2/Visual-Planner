import 'package:flutter/material.dart';

import '../../../../Core/helper/helper.dart';

class GetPremiumCard extends StatelessWidget {
  const GetPremiumCard({
    required this.onPressed,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final Color? backgroundColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: backgroundColor ?? Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(kBorderRadius),
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 250,
              maxWidth: 350,
              minHeight: 200,
              maxHeight: 200,
            ),
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: const [
                Align(
                  alignment: Alignment.topRight,
                  child: Image(
                    image: AssetImage(
                      "assets/images/wavy-bus.png",
                    ),
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  // child: SvgPicture.asset(
                  //   ImageVectorPath.wavyBus,
                  //   width: 180,
                  //   height: 180,
                  //   fit: BoxFit.contain,
                  // ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: _Info(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Get\nDaily\nQuotes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "If you can dream it\nYou can do it....",
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
