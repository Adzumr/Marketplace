import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/controllers/controllers/cart_controller.dart';
import 'package:marketplace/controllers/controllers/order_controller.dart';
import 'package:marketplace/core/utils/app_constants.dart';
import 'package:marketplace/core/utils/enums.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:marketplace/models/item_model.dart';
import 'package:marketplace/models/my_order_model.dart';

import '../../../controllers/controllers/auth_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  bool? isLoading = false;
  final cartController = Get.put(CartController());
  final authController = Get.find<AuthController>();
  final orderController = Get.find<OrderController>();

  getData() async {
    setState(() {
      isLoading = true;
    });
    cartController.getCartsStream(
      userId: authController.userModel!.id,
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
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        leading: BackButton(
          color: theme.colorScheme.surface,
        ),
        centerTitle: true,
        title: Text(
          "Cart",
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.surface,
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => getData(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<List<ItemModel>>(
              stream: cartController.getCartsStream(
                userId: authController.userModel!.id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<ItemModel> items = snapshot.data ?? [];

                  double totalPrice = items.fold(
                      0,
                      (previousValue, item) =>
                          previousValue + (item.total ?? 0));

                  return items.isEmpty
                      ? Center(
                          child: Text(
                            "Empty",
                            style: theme.textTheme.titleLarge,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final order = items[index];

                                  return ListTile(
                                    onTap: () {
                                      showAdaptiveDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog.adaptive(
                                              title: Text(
                                                "Remove ${order.product!}",
                                                style:
                                                    theme.textTheme.titleLarge,
                                              ),
                                              content: Text(
                                                "Are you sure?",
                                                style:
                                                    theme.textTheme.bodyLarge,
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    try {
                                                      await cartController
                                                          .deleteItem(
                                                        userId: authController
                                                            .userModel!.id,
                                                        item: order,
                                                      );
                                                    } on Exception catch (e) {
                                                      AppConstants()
                                                          .throwError("$e");
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Yes",
                                                  ),
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text(
                                                    "No",
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    leading: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: order.picture ?? "",
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) {
                                            return const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(),
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            return const Icon(
                                              Icons.account_circle_outlined,
                                              size: 40,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      "${order.product}",
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    subtitle: Text(
                                      "${order.quantity} unit(s)",
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    trailing: Text(
                                      "${order.total}".toCurrency(),
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.bodyLarge!.copyWith(
                                        color: theme.colorScheme.error,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            isLoading == true
                                ? const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      showAdaptiveDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog.adaptive(
                                            title: Text(
                                              "Place Order",
                                              style: theme.textTheme.titleLarge,
                                            ),
                                            content: Text(
                                              "Are you sure?",
                                              style: theme.textTheme.bodyLarge,
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  double cartTotal = items.fold(
                                                      0,
                                                      (previousValue, item) =>
                                                          previousValue +
                                                          (item.total ?? 0));

                                                  final order = MyOrderModel(
                                                    date:
                                                        DateTime.now().toDate(),
                                                    items: items,
                                                    orderStatus: OrderStatus
                                                        .unprocessed.name,
                                                    paymentStatus: PaymentStatus
                                                        .notPaid.name,
                                                    totalAmount: cartTotal,
                                                    user: authController
                                                        .userModel!,
                                                  );
                                                  Get.back();
                                                  try {
                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    await orderController
                                                        .placeOrder(
                                                      orderModel: order,
                                                    )
                                                        .then((value) {
                                                      cartController.clearCart(
                                                        userId: authController
                                                            .userModel!.id,
                                                      );
                                                    });
                                                  } finally {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  "Yes",
                                                ),
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text(
                                                  "No",
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            "Place order",
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "$totalPrice".toCurrency(),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
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
