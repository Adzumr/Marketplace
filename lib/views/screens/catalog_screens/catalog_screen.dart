import 'package:marketplace/core/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Manage Your Supermarket Efficiently",
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      "This dashboard provides you with the tools to oversee orders, manage inventory, and keep your supermarket running smoothly.",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(
                      child: SizedBox.shrink(),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Manage Customers",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRouteNames.customers);
                      },
                      child: const Text(
                        "Customers",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(
                      child: SizedBox.shrink(),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Manage Products",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRouteNames.products);
                      },
                      child: const Text(
                        "Products",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
