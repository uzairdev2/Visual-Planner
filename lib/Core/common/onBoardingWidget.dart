import 'package:flutter/material.dart';

import '../helper/onBoardingModels.dart';

class onBoadingPage extends StatelessWidget {
  const onBoadingPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  final onBoardingModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(30.0),
      color: model.bgcolor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            model.image,
            height: size.height * 0.5,
          ),
          Text(
            model.title,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          Text(
            model.CounterText,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(
            height: 80.0,
          ),
        ],
      ),
    );
  }
}
