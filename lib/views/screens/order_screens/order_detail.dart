import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/controllers/controllers/order_controller.dart';
import 'package:marketplace/core/utils/enums.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:marketplace/models/my_order_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_constants.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool? isLoading = false;
  @override
  void initState() {
    orderModel = Get.arguments;
    super.initState();
  }

  MyOrderModel? orderModel;
  final orderController = Get.find<OrderController>();
  final authController = Get.find<AuthController>();
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
        actions: [
          IconButton.filledTonal(
            onPressed: () async {
              AppConstants().makeCall(
                telephoneNumber: orderModel!.user!.phone,
              );
            },
            icon: const Icon(
              Icons.call,
            ),
          ),
        ],
        title: Text(
          "Order Detail",
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.surface,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      authController.userModel!.isAdmin == true
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  title: Text(
                                    "Customer",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  subtitle: Text(
                                    "${orderModel!.user!.name}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ListTile(
                                  title: Text(
                                    "Delivery Address",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  subtitle: Text(
                                    "${orderModel!.user!.address}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ListTile(
                                  title: Text(
                                    "Date",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  subtitle: Text(
                                    "${orderModel!.date}",
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ListTile(
                                  title: Text(
                                    "Status",
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  subtitle: Text(
                                    orderModel!.orderStatus!.capitalizeFirst!,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                      ListTile(
                        title: Text(
                          "Items",
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      Column(
                        children:
                            List.generate(orderModel!.items!.length, (index) {
                          final item = orderModel!.items![index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: item.picture ?? "",
                                height: 250,
                                fit: BoxFit.fill,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.account_circle_outlined,
                                  size: 150,
                                ),
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              ),
                            ),
                            title: Text(
                              "${item.product}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: theme.textTheme.bodyLarge,
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.price}".toCurrency(),
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  " x ${item.quantity}",
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              "${item.quantity! * item.price!}".toCurrency(),
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          );
                        }),
                      ),
                      ListTile(
                        title: Text(
                          "Total Amount",
                          style: theme.textTheme.titleMedium,
                        ),
                        trailing: Text(
                          "${orderModel!.totalAmount}".toCurrency(),
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.error,
                            fontSize: 20,
                            fontFamily: "roboto",
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : authController.userModel!.isAdmin == true
                      ? ElevatedButton(
                          onPressed: () async {
                            orderModel!.orderStatus ==
                                    OrderStatus.unprocessed.name
                                ? processOrder(
                                    context,
                                    theme,
                                  )
                                : orderModel!.orderStatus ==
                                            OrderStatus.accepted.name &&
                                        orderModel!.paymentStatus ==
                                            PaymentStatus.paid.name
                                    ? completeOrder(
                                        context,
                                        theme,
                                      )
                                    : Get.back();
                          },
                          child: Text(
                            orderModel!.orderStatus ==
                                    OrderStatus.unprocessed.name
                                ? "Process Order"
                                : orderModel!.orderStatus ==
                                            OrderStatus.accepted.name &&
                                        orderModel!.paymentStatus ==
                                            PaymentStatus.paid.name
                                    ? "Mark Order Completed"
                                    : "Close",
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            orderModel!.orderStatus ==
                                        OrderStatus.accepted.name &&
                                    orderModel!.paymentStatus ==
                                        PaymentStatus.notPaid.name
                                ? makePayment(
                                    context,
                                    theme,
                                  )
                                : Get.back();
                          },
                          child: Text(
                            orderModel!.orderStatus ==
                                        OrderStatus.accepted.name &&
                                    orderModel!.paymentStatus ==
                                        PaymentStatus.notPaid.name
                                ? "Make Payment"
                                : "Close",
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> makePayment(
    BuildContext context,
    ThemeData theme,
  ) {
    final formKey = GlobalKey<FormState>();
    return showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            title: Text(
              "Make Payment",
              style: theme.textTheme.titleLarge,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CreditCardForm(
                  formKey: formKey,
                  cardNumber: "",
                  expiryDate: "",
                  cardHolderName: "",
                  cvvCode: "",
                  onCreditCardModelChange: (CreditCardModel data) {
                    debugPrint("Card: ${data.expiryDate}");
                  },
                  obscureCvv: true,
                  obscureNumber: false,
                  isHolderNameVisible: true,
                  isCardNumberVisible: true,
                  isExpiryDateVisible: true,
                  enableCvv: true,
                  cardNumberValidator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter Card Number";
                    }
                    return null;
                  },
                  cardHolderValidator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter Card Name";
                    }
                    return null;
                  },
                  expiryDateValidator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter Expiry Date";
                    }
                    return null;
                  },
                  cvvValidator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter Card CVV";
                    }
                    return null;
                  },
                  cvvValidationMessage: 'Please input a valid CVV',
                  dateValidationMessage: 'Please input a valid date',
                  numberValidationMessage: 'Please input a valid number',
                  onFormComplete: () {},
                  autovalidateMode: AutovalidateMode.always,
                  disableCardNumberAutoFillHints: false,
                  inputConfiguration: InputConfiguration(
                    cardNumberTextStyle: theme.textTheme.bodyLarge,
                    cardHolderTextStyle: theme.textTheme.bodyLarge,
                    expiryDateTextStyle: theme.textTheme.bodyLarge,
                    cvvCodeTextStyle: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Get.back();
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await orderController.updateOrder(
                      orderId: orderModel!.id,
                      orderStatus: OrderStatus.accepted.name,
                      paymentStatus: PaymentStatus.paid.name,
                    );
                  } on FirebaseException catch (e) {
                    AppConstants().throwError(
                      "${e.message}",
                    );
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: const Text(
                  "Pay",
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                ),
              ),
            ],
          );
        });
  }

  Future<dynamic> processOrder(BuildContext context, ThemeData theme) {
    return showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            title: Text(
              "Process Order",
              style: theme.textTheme.titleLarge,
            ),
            content: Text(
              "You can ACCEPT or REJECT Order",
              style: theme.textTheme.bodyLarge,
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Get.back();
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await orderController.updateOrder(
                      orderId: orderModel!.id,
                      orderStatus: OrderStatus.accepted.name,
                      paymentStatus: PaymentStatus.notPaid.name,
                    );
                  } on FirebaseException catch (e) {
                    AppConstants().throwError(
                      "${e.message}",
                    );
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: const Text(
                  "Accept",
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  Get.back();
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await orderController.updateOrder(
                      orderId: orderModel!.id,
                      orderStatus: OrderStatus.rejected.name,
                      paymentStatus: PaymentStatus.notPaid.name,
                    );
                  } on FirebaseException catch (e) {
                    AppConstants().throwError(
                      "${e.message}",
                    );
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: const Text(
                  "Reject",
                ),
              ),
            ],
          );
        });
  }

  Future<dynamic> completeOrder(BuildContext context, ThemeData theme) {
    return showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            title: Text(
              "Mark Complete",
              style: theme.textTheme.titleLarge,
            ),
            content: Text(
              "Are you sure?",
              style: theme.textTheme.bodyLarge,
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Get.back();
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await orderController.updateOrder(
                      orderId: orderModel!.id,
                      orderStatus: OrderStatus.completed.name,
                      paymentStatus: PaymentStatus.paid.name,
                    );
                  } on FirebaseException catch (e) {
                    AppConstants().throwError(
                      "${e.message}",
                    );
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
                onPressed: () async {
                  Get.back();
                },
                child: const Text(
                  "No",
                ),
              ),
            ],
          );
        });
  }
}
