import 'package:cached_network_image/cached_network_image.dart';
import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/controllers/controllers/product_controller.dart';
import 'package:marketplace/core/utils/app_constants.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routing/route_names.dart';
import '../../../models/product_model.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final authController = Get.find<AuthController>();
  final dishController = Get.put(ProductController());
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
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateTime.now().getGreeting(),
                          style: theme.textTheme.titleLarge,
                        ),
                        authController.userModel!.role != "shopkeeper"
                            ? IconButton.outlined(
                                onPressed: () {
                                  Get.toNamed(AppRouteNames.cart);
                                },
                                icon: const Icon(
                                  Icons.shopping_cart,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome to ${AppConstants().appName}! \n"
                      "Your personalized shopping experience starts here. Browse our extensive catalog, view your recent orders, and discover exclusive deals tailored just for you.",
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 5,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Text(
                "Browse Catalog",
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Expanded(
                flex: 5,
                child: StreamBuilder<List<ProductModel>>(
                  stream: dishController.getProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<ProductModel> products = snapshot.data ?? [];
                      // Use the 'debtors' list to build your UI.
                      return products.isEmpty
                          ? Center(
                              child: Text(
                                "Empty Catalog",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            )
                          : ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                final product = products[index];
                                return ProductTile(
                                  product: product,
                                );
                              },
                            );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRouteNames.product,
            arguments: product,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: product.picture ?? "",
                height: 200,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 50,
                    ),
                  );
                },
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${product.name}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text(
                    "${product.price}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
