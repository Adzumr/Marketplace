import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../core/routing/route_names.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionState);
  }

  _updateConnectionState(ConnectivityResult? connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.toNamed(AppRouteNames.noNetwork);
    } else {
      if (Get.currentRoute == AppRouteNames.noNetwork) {
        Get.back();
      }
    }
  }
}
