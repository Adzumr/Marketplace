import 'package:marketplace/controllers/bindings/cart_binding.dart';
import 'package:marketplace/controllers/bindings/order_binding.dart';
import 'package:marketplace/views/screens/catalog_screens/add_product_screen.dart';
import 'package:marketplace/views/screens/catalog_screens/catalog_screen.dart';
import 'package:marketplace/views/screens/catalog_screens/customers_screen.dart';
import 'package:marketplace/views/screens/catalog_screens/product_screen.dart';
import 'package:marketplace/views/screens/catalog_screens/user_home_screen.dart';
import 'package:marketplace/views/screens/order_screens/processed_orders.dart';
import 'package:marketplace/views/screens/order_screens/unprocessed_orders.dart';
import 'package:marketplace/views/screens/cart/cart_screen.dart';
import 'package:marketplace/views/screens/order_screens/orders_screen.dart';
import 'package:marketplace/views/screens/order_screens/completed_orders.dart';
import 'package:marketplace/views/screens/order_screens/order_detail.dart';
import 'package:marketplace/views/screens/authentication/setting_screens/profile_screen.dart';
import 'package:marketplace/views/screens/authentication/setting_screens/update_profile.dart';
import 'package:marketplace/views/screens/authentication/main_screen.dart';
import 'package:marketplace/views/screens/authentication/register_screen.dart';
import 'package:get/get.dart';
import '../../controllers/bindings/auth_binding.dart';
import '../../controllers/bindings/dish_binding.dart';
import '../../views/screens/catalog_screens/products_screen.dart';
import '../../views/screens/authentication/intro_screen.dart';
import '../../views/screens/authentication/login_screen.dart';
import '../../views/screens/authentication/no_network_screen.dart';
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
      page: () => const RegisterScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.main}',
      bindings: [
        AuthBinding(),
        CartBinding(),
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
        CartBinding(),
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

    /// Admin Pages
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.addProduct}',
      bindings: [
        AuthBinding(),
        DishBinding(),
        CartBinding(),
      ],
      page: () => const AddProductScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.catalog}',
      bindings: [
        AuthBinding(),
        DishBinding(),
        CartBinding(),
      ],
      page: () => const CatalogScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.customers}',
      bindings: [
        AuthBinding(),
        CartBinding(),
      ],
      page: () => const CustomersScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.product}',
      bindings: [
        AuthBinding(),
        DishBinding(),
        OrderBinding(),
        CartBinding(),
      ],
      page: () => const ProductScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.products}',
      bindings: [
        AuthBinding(),
        DishBinding(),
        CartBinding(),
      ],
      page: () => const ProductsScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.acceptedOrders}',
      bindings: [
        AuthBinding(),
        CartBinding(),
      ],
      page: () => const ProcessedOrdersScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.completedOrders}',
      bindings: [
        AuthBinding(),
        CartBinding(),
      ],
      page: () => const CompletedOrdersScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.orders}',
      bindings: [
        AuthBinding(),
        DishBinding(),
        OrderBinding(),
        CartBinding(),
      ],
      page: () => const OrdersScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.allOrders}',
      bindings: [
        AuthBinding(),
        DishBinding(),
        OrderBinding(),
        CartBinding(),
      ],
      page: () => const UnprocessedOrdersScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.order}',
      bindings: [
        AuthBinding(),
        DishBinding(),
        OrderBinding(),
        CartBinding(),
      ],
      page: () => const OrderScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.cart}',
      bindings: [
        AuthBinding(),
        CartBinding(),
        OrderBinding(),
      ],
      page: () => const CartScreen(),
    ),
    GetPage(
      fullscreenDialog: true,
      participatesInRootNavigator: true,
      opaque: true,
      name: '/${AppRouteNames.home}',
      bindings: [
        AuthBinding(),
        DishBinding(),
        CartBinding(),
      ],
      page: () => const UserHomeScreen(),
    ),
  ];
}
