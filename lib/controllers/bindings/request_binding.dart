import 'package:marketplace/controllers/controllers/request_controller.dart';
import 'package:get/get.dart';

class RequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestController>(
      () => RequestController(),
    );
  }
}
