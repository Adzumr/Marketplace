import 'package:marketplace/views/screens/request_screens/user_home_screen.dart';
import 'package:marketplace/views/screens/profile_screens/profile_screen.dart';
import 'package:marketplace/views/screens/profile_screens/update_profile.dart';
import 'package:marketplace/views/screens/authentication/main_screen.dart';
import 'package:marketplace/views/screens/authentication/register_customer_screen.dart';
import 'package:get/get.dart';
import '../../controllers/bindings/auth_binding.dart';
import '../../controllers/bindings/request_binding.dart';
import '../../views/screens/authentication/register_shopkeer__screen.dart';
import '../../views/screens/authentication/intro_screen.dart';
import '../../views/screens/authentication/login_screen.dart';
import '../../views/screens/authentication/no_network_screen.dart';
import '../../views/screens/request_screens/add_request_screen.dart';
import '../../views/screens/request_screens/shopkeeper_home_screen.dart';
import 'route_names.dart';

class AppRoutesConfiguration {
  static List<GetPage> myRoutes = [
    /// General Pages
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.introduction}',
      binding: AuthBinding(),
      page: () => const IntroductionScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.noNetwork}',
      binding: AuthBinding(),
      page: () => const NoNetworkScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.login}',
      binding: AuthBinding(),
      page: () => const LoginScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.register}',
      binding: AuthBinding(),
      page: () => const RegisterCustomerScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.registerShopkeer}',
      binding: AuthBinding(),
      page: () => const RegisterShopkeerScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.main}',
      bindings: [
        AuthBinding(),
      ],
      page: () => const MainScreen(),
    ),

    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.profile}',
      bindings: [
        AuthBinding(),
      ],
      page: () => const ProfileScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.updateProfile}',
      binding: AuthBinding(),
      page: () => const UpdateProfileScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.homeCustomer}',
      bindings: [
        AuthBinding(),
        RequestBinding(),
      ],
      page: () => const UserHomeScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.addRequest}',
      bindings: [
        AuthBinding(),
        RequestBinding(),
      ],
      page: () => const AddRequestScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.homeShopkeeper}',
      bindings: [
        AuthBinding(),
        RequestBinding(),
      ],
      page: () => const ShopkeeperHomeScreen(),
    ),
  ];
}
