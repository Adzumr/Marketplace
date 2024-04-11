import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../core/routing/route_names.dart';

/// A controller class that extends [GetxController] to manage network connectivity changes.
/// It utilizes the [Connectivity] plugin to listen for connectivity updates and responds accordingly.
class NetworkController extends GetxController {
  /// Instance of [Connectivity] to check the network status.
  final Connectivity _connectivity = Connectivity();

  /// Called immediately after the controller is allocated in memory.
  /// Here, it initializes the listener for connectivity changes.
  @override
  void onInit() {
    super
        .onInit(); // Calls the onInit method of the superclass (GetxController).
    // Start listening to the connectivity changes. When connectivity changes,
    // [_updateConnectionState] is called with the new connectivity status.
    _connectivity.onConnectivityChanged.listen(_updateConnectionState);
  }

  /// A method to handle updates in network connectivity.
  /// This method routes the user to different pages based on the connectivity status.
  ///
  /// [connectivityResult] holds the current state of network connectivity.
  void _updateConnectionState(ConnectivityResult? connectivityResult) {
    // Check if there is no internet connection.
    if (connectivityResult == ConnectivityResult.none) {
      // If no internet, navigate to the 'noNetwork' page.
      Get.toNamed(AppRouteNames.noNetwork);
    } else {
      // If the current route is the 'noNetwork' page and the connectivity is restored,
      // navigate back to the previous page.
      if (Get.currentRoute == AppRouteNames.noNetwork) {
        Get.back();
      }
    }
  }
}
