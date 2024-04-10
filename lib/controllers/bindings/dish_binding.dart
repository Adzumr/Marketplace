import 'package:marketplace/controllers/controllers/product_controller.dart';
import 'package:get/get.dart';

class DishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
  }
}
