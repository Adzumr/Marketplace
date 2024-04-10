import 'package:cached_network_image/cached_network_image.dart';
import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/controllers/controllers/cart_controller.dart';
import 'package:marketplace/controllers/controllers/product_controller.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:marketplace/models/item_model.dart';
import 'package:marketplace/models/product_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_constants.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool? isLoading = false;
  @override
  void initState() {
    product = Get.arguments;
    super.initState();
  }

  ProductModel? product;
  final dishController = Get.find<ProductController>();
  final authController = Get.find<AuthController>();
  final cartController = Get.find<CartController>();
  final formKey = GlobalKey<FormState>();
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
          "Product Details",
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
                      Hero(
                        tag: product!.name!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: product!.picture ?? "",
                            height: 200,
                            fit: BoxFit.fill,
                            errorWidget: (context, url, error) => const Icon(
                              Icons.account_circle_outlined,
                              size: 150,
                            ),
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary,
                          child: const Icon(
                            Icons.restaurant_menu,
                          ),
                        ),
                        title: Text(
                          "${product!.name}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary,
                          child: const Icon(
                            Icons.attach_money,
                          ),
                        ),
                        title: Text(
                          "${product!.price}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary,
                          child: const Icon(
                            Icons.description,
                          ),
                        ),
                        title: Text(
                          "${product!.description}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : authController.userModel!.role == "shopkeeper"
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                          ),
                          onPressed: () {
                            deleteProduct(
                              context,
                              theme,
                            );
                          },
                          child: const Text("Delete Product"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            placeOrder(
                              context,
                              theme,
                            );
                          },
                          child: const Text(
                            "Add to Cart",
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> placeOrder(BuildContext context, ThemeData theme) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        final quantity = TextEditingController(text: "1");
        return AlertDialog.adaptive(
          title: Text(
            "Add to Cart",
            style: theme.textTheme.titleMedium,
          ),
          content: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${product!.name}",
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      "${product!.price}".toCurrency(),
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: quantity,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter Quantity";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: "Quanity",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Get.back();
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    final item = ItemModel(
                      product: product!.name,
                      picture: product!.picture,
                      price: product!.price!,
                      quantity: int.tryParse(quantity.text.trim())!,
                      total: product!.price! *
                          double.tryParse(
                            quantity.text.trim(),
                          )!,
                    );
                    await cartController.addItem(
                      item: item,
                      userId: authController.userModel!.id!,
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
                }
              },
              child: const Text(
                "Yes",
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> deleteProduct(BuildContext context, ThemeData theme) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(
            "Delete Dish",
            style: theme.textTheme.titleMedium,
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
                  await dishController.deleteProduct(
                    dish: product,
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
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
              ),
            )
          ],
        );
      },
    );
  }
}
