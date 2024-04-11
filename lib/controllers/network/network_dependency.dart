import 'package:get/get.dart';

import 'network_controller.dart';

/// This class is responsible for setting up dependency injections related
/// to network operations in the application.
class NetWorkDependencyInjection {
  /// Initializes the dependencies needed by the network layer of the application.
  ///
  /// This method registers the `NetworkController` as a singleton in the application's
  /// dependency injector using the GetX framework. By marking it as `permanent`,
  /// the `NetworkController` stays in memory and is not disposed automatically
  /// when it's no longer in use.
  ///
  /// Example Usage:
  /// ```
  /// void main() {
  ///   NetWorkDependencyInjection.init(); // Set up network dependencies
  ///   runApp(MyApp());
  /// }
  /// ```
  static void init() {
    Get.put<NetworkController>(
      NetworkController(),
      permanent: true,
    );
  }
}
