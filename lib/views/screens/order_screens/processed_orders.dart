import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/models/my_order_model.dart';

import '../../../controllers/controllers/auth_controller.dart';
import '../../../controllers/controllers/order_controller.dart';
import '../../../core/utils/enums.dart';
import '../../widgets/order_tile.dart';

class ProcessedOrdersScreen extends StatefulWidget {
  const ProcessedOrdersScreen({super.key});

  @override
  State<ProcessedOrdersScreen> createState() => _ProcessedOrdersScreenState();
}

class _ProcessedOrdersScreenState extends State<ProcessedOrdersScreen> {
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
    authController.userModel!.isAdmin == true
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
              stream: authController.userModel!.isAdmin == true
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
                  List<MyOrderModel> processedOrders = [];
                  for (var order in orders) {
                    if (order.orderStatus == OrderStatus.accepted.name ||
                        order.orderStatus == OrderStatus.rejected.name) {
                      processedOrders.add(order);
                    }
                  }
                  return processedOrders.isEmpty
                      ? Center(
                          child: Text(
                            "No Processed Orders",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )
                      : ListView.builder(
                          itemCount: processedOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            final order = processedOrders[index];
                            return order.orderStatus ==
                                        OrderStatus.accepted.name ||
                                    order.orderStatus ==
                                        OrderStatus.rejected.name
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
