import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../helper/helper.dart';
import '../helper/onBoardingModels.dart';
import '../common/onBoardingWidget.dart';

class onBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPageIndex = 0.obs;

  final pages = [
    onBoadingPage(
      model: onBoardingModel(
          image: "assets/images/happy-2.png",
          title: "The #1 software development tool for the teams",
          CounterText: "1/7",
          bgcolor: boardingColor1),
    ),
    onBoadingPage(
      model: onBoardingModel(
          image: "assets/images/happy-2.png",
          title: "Tracks the task completion time",
          CounterText: "2/7",
          bgcolor: boardingColor2),
    ),
    onBoadingPage(
      model: onBoardingModel(
          image: "assets/images/happy-2.png",
          title: "Prioritize your work using certain filters",
          CounterText: "3/7",
          bgcolor: boardingColor3),
    ),
    onBoadingPage(
      model: onBoardingModel(
          image: "assets/images/happy-2.png",
          title:
              "Get real time notification after when each activity is completed",
          CounterText: "4/7",
          bgcolor: boardingColor1),
    ),
    onBoadingPage(
      model: onBoardingModel(
          image: "assets/images/happy-2.png",
          title: "All the ongoing acivities can easily be accessed",
          CounterText: "5/7",
          bgcolor: boardingColor2),
    ),
    onBoadingPage(
      model: onBoardingModel(
          image: "assets/images/happy-2.png",
          title: "Tracks the project goal",
          CounterText: "6/7",
          bgcolor: boardingColor3),
    ),
    onBoadingPage(
      model: onBoardingModel(
          image: "assets/images/happy-2.png",
          title: "Swipe & drag to the next phase when previous is completed",
          CounterText: "7/7",
          bgcolor: boardingColor1),
    ),
  ];
  animatedToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }

  void onPageChangeCallback(int activePageIndex) {
    currentPageIndex.value = activePageIndex;
  }
}
