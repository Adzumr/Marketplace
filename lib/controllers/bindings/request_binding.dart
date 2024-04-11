import 'package:marketplace/controllers/controllers/request_controller.dart';
import 'package:get/get.dart';

/// `RequestBinding` class extends `Bindings` to manage the dependency injection for `RequestController`.
///
/// This class is used to lazily inject an instance of `RequestController` when it is first needed.
/// The `dependencies` method is overridden to specify the injection mechanism.
class RequestBinding extends Bindings {
  /// Overrides the `dependencies` method from the `Bindings` class to setup the injection of `RequestController`.
  ///
  /// This method uses the `Get.lazyPut` function to lazily instantiate `RequestController` when it is first required.
  /// The lazy instantiation helps in saving resources as the `RequestController` is only created when it is necessary.
  @override
  void dependencies() {
    Get.lazyPut<RequestController>(
      () => RequestController(),
    );
  }
}
