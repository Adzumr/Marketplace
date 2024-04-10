import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/controllers/controllers/order_controller.dart';
import 'package:marketplace/core/utils/enums.dart';
import 'package:marketplace/models/my_order_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/order_tile.dart';

class UnprocessedOrdersScreen extends StatefulWidget {
  const UnprocessedOrdersScreen({super.key});

  @override
  State<UnprocessedOrdersScreen> createState() =>
      _UnprocessedOrdersScreenState();
}

class _UnprocessedOrdersScreenState extends State<UnprocessedOrdersScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  bool? isLoading = false;
  final ordersController = Get.put(OrderController());
  final authController = Get.find<AuthController>();

  getData() async {
    setState(() {
      isLoading = true;
    });
    authController.userModel!.role == "shopkeeper"
        ? ordersController.getOrdersStream()
        : ordersController.myOrderStream(
            customerId: authController.userModel!.id,
          );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: RefreshIndicator.adaptive(
        onRefresh: () => getData(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<List<MyOrderModel>>(
              stream: authController.userModel!.role == "shopkeeper"
                  ? ordersController.getOrdersStream()
                  : ordersController.myOrderStream(
                      customerId: authController.userModel!.id,
                    ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<MyOrderModel> orders = snapshot.data ?? [];
                  List<MyOrderModel> unprocessedOrders = [];
                  for (var order in orders) {
                    if (order.orderStatus == OrderStatus.unprocessed.name) {
                      unprocessedOrders.add(order);
                    }
                  }
                  return unprocessedOrders.isEmpty
                      ? Center(
                          child: Text(
                            "No Unprocessed Orders",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )
                      : ListView.builder(
                          itemCount: unprocessedOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            final order = unprocessedOrders[index];
                            return order.orderStatus ==
                                    OrderStatus.unprocessed.name
                                ? OrderTile(
                                    order: order,
                                  )
                                : const SizedBox.shrink();
                          },
                        );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
