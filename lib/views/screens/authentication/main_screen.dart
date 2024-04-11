import 'package:marketplace/core/utils/enums.dart';
import 'package:marketplace/views/screens/catalog_screens/shopkeeper_home_screen.dart';
import 'package:marketplace/views/screens/catalog_screens/user_home_screen.dart';
import 'package:marketplace/views/screens/authentication/setting_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers/auth_controller.dart';

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
        tooltip: "Requests",
        label: 'Requests',
      ),
      NavigationDestination(
        selectedIcon: Icon(
          Icons.settings,
          color: theme.colorScheme.surface,
        ),
        icon: const Icon(Icons.settings_outlined),
        tooltip: "Profile",
        label: 'Profile',
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
          authController.userModel!.role == Roles.shopkeeper.name
              ? const ShopkeeperHomeScreen()
              : const UserHomeScreen(),

          /// Profile page
          const ProfileScreen(),
        ][currentPageIndex],
      ),
    );
  }
}
