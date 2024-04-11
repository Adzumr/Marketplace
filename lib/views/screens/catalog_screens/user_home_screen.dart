import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/controllers/controllers/request_controller.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routing/route_names.dart';
import '../../../models/product_model.dart';
import '../../widgets/request_tile.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final authController = Get.find<AuthController>();
  final requestController = Get.put(RequestController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Get.toNamed(AppRouteNames.addRequest);
        },
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    DateTime.now().getGreeting(),
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                "My Requests",
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Expanded(
                flex: 5,
                child: StreamBuilder<List<RequestModel>>(
                  stream: requestController.getRequestsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<RequestModel> orders = snapshot.data ?? [];
                      List<RequestModel> requests = [];
                      for (var order in orders) {
                        if (order.customerId == authController.userModel!.id) {
                          requests.add(order);
                        }
                      }
                      return requests.isEmpty
                          ? Center(
                              child: Text(
                                "Empty Resquest",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            )
                          : ListView.builder(
                              itemCount: requests.length,
                              itemBuilder: (BuildContext context, int index) {
                                final request = requests[index];
                                return RequestTile(
                                  request: request,
                                  onPressed: () async {
                                    await requestController.sendNotification(
                                      token:
                                          "eSmv6gplTIq_nDP1uPIxG6:APA91bEbGeO8a_6SxSLul0U6oW5O72t2KitgfrbqJtycU7iwZMrK6DgyoihlgZ2NG5ojLvRQdbNJ2306VItQn5YeNLPwq5PofxR7x962byULSAkUx_A9Psmf0mEJy39mnyM2Wuoas07V",
                                    );
                                    // showRequestionDetail(
                                    //   context,
                                    //   request,
                                    // );
                                  },
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

  Future<dynamic> showRequestionDetail(
    BuildContext context,
    RequestModel request,
  ) {
    final theme = Theme.of(context);
    return showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            title: Text(
              "${request.name}",
              style: theme.textTheme.titleLarge,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${request.tag}",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "${request.description}",
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Close",
                ),
              ),
            ],
          );
        });
  }
}
