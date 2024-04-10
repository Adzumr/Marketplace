import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:marketplace/models/my_order_model.dart';

class CartDetailScreen extends StatefulWidget {
  const CartDetailScreen({super.key});

  @override
  State<CartDetailScreen> createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  @override
  void initState() {
    order = Get.arguments;
    super.initState();
  }

  MyOrderModel? order;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              "${order!.totalAmount}".toCurrency(),
              style: theme.textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}
