import 'package:cached_network_image/cached_network_image.dart';
import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routing/route_names.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        leading: authController.userModel!.role == "shopkeeper"
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
        centerTitle: true,
        actions: [
          IconButton.filled(
            onPressed: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return AlertDialog.adaptive(
                    title: Text(
                      "Log out",
                      style: theme.textTheme.titleLarge,
                    ),
                    content: Text(
                      "Are you sure?",
                      style: theme.textTheme.bodyLarge,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          await authController.signOut();
                        },
                        child: const Text("Yes"),
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
            },
            icon: const Icon(
              Icons.power_settings_new_rounded,
            ),
          )
        ],
        title: Text(
          "Profile",
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: authController.userModel!.picture ?? "",
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
                      const SizedBox(height: 20),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary,
                          child: const Icon(
                            Icons.person,
                          ),
                        ),
                        title: Text(
                          "${authController.userModel!.name}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary,
                          child: const Icon(
                            Icons.location_on,
                          ),
                        ),
                        title: Text(
                          "${authController.userModel!.tag}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary,
                          child: const Icon(
                            Icons.email,
                          ),
                        ),
                        title: Text(
                          "${authController.userModel!.email}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary,
                          child: const Icon(
                            Icons.phone_android,
                          ),
                        ),
                        title: Text(
                          "${authController.userModel!.phone}",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  Get.toNamed(AppRouteNames.updateProfile);
                },
                child: const Text("Edit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
