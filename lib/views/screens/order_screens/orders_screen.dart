import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:marketplace/views/screens/order_screens/processed_orders.dart';
import 'package:marketplace/views/screens/order_screens/completed_orders.dart';
import 'package:marketplace/views/screens/order_screens/unprocessed_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routing/route_names.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: context.deviceSize.flipped.aspectRatio * 20,
          centerTitle: true,
          title: Material(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Orders",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: [
            authController.userModel!.role != "shopkeeper"
                ? IconButton.filledTonal(
                    onPressed: () {
                      Get.toNamed(
                        AppRouteNames.cart,
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
          bottom: TabBar(
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: theme.textTheme.titleMedium,
            tabs: const [
              Tab(
                text: "Unprocessed",
              ),
              Tab(
                text: "Processed",
              ),
              Tab(
                text: "Completed",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UnprocessedOrdersScreen(),
            ProcessedOrdersScreen(),
            CompletedOrdersScreen(),
          ],
        ),
      ),
    );
  }
}
