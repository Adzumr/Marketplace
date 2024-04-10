import 'package:marketplace/views/screens/catalog_screens/user_home_screen.dart';
import 'package:marketplace/views/screens/order_screens/orders_screen.dart';
import 'package:marketplace/views/screens/authentication/setting_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers/auth_controller.dart';
import '../catalog_screens/catalog_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final authController = Get.find<AuthController>();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<NavigationDestination> tabs = [
      NavigationDestination(
        selectedIcon: Icon(
          Icons.category,
          color: theme.colorScheme.surface,
        ),
        icon: const Icon(Icons.category_outlined),
        tooltip: "Catalog",
        label: 'Catalog',
      ),
      NavigationDestination(
        selectedIcon: Icon(
          Icons.history,
          color: theme.colorScheme.surface,
        ),
        icon: const Icon(Icons.history_outlined),
        tooltip: "Orders",
        label: 'Orders',
      ),
      NavigationDestination(
        selectedIcon: Icon(
          Icons.settings,
          color: theme.colorScheme.surface,
        ),
        icon: const Icon(Icons.settings_outlined),
        tooltip: "Settings",
        label: 'Settings',
      ),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Theme.of(context).colorScheme.secondary,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: currentPageIndex,
          destinations: tabs,
        ),
        body: <Widget>[
          /// Home page
          authController.userModel!.role == "shopkeeper"
              ? const CatalogScreen()
              : const UserHomeScreen(),

          /// Appointment page
          const OrdersScreen(),

          /// Profile page
          const ProfileScreen()
        ][currentPageIndex],
      ),
    );
  }
}
