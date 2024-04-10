import 'package:get/get.dart';

import 'network_controller.dart';

class NetWorkDependencyInjection {
  static void init() {
    Get.put<NetworkController>(
      NetworkController(),
      permanent: true,
    );
  }
}
