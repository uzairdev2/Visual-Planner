import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visual_planner/Core/helper/helper.dart';
import 'package:visual_planner/Core/routes/routes.dart';

class UpgradePremiumCard extends StatelessWidget {
  const UpgradePremiumCard({
    required this.onPressed,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final Color? backgroundColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius),
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: 250,
            minHeight: 150,
            maxHeight: 250,
          ),
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: const [
              Padding(
                padding: EdgeInsets.only(
                  top: 80,
                ),
                child: Image(
                  image: AssetImage("assets/images/happy.png"),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: _Info(),
              ),
            ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _price(),
        const SizedBox(
          height: 10,
        ),
        _price1(),
        const SizedBox(
          height: kSpacing,
        ),
      ],
    );
  }

  Widget _price() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(Routes.addProject);
      },
      child: Row(
        children: [
          Icon(Icons.add),
          SizedBox(
            width: kSpacing,
          ),
          Text("Add Project"),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _price1() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(Routes.CreateSprint);
      },
      child: Row(
        children: [
          Icon(Icons.add),
          SizedBox(
            width: kSpacing,
          ),
          Text("Add WorkPlace"),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
    );
  }
}
