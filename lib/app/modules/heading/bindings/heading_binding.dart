import 'package:get/get.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/heading_controller.dart';

class HeadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HeadingController>(() => HeadingController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
