import 'package:get/get.dart';

import '../../../../Core/controllers/dashboardController.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}
