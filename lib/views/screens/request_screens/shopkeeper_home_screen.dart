import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/controllers/controllers/request_controller.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/product_model.dart';
import '../../widgets/request_tile.dart';

class ShopkeeperHomeScreen extends StatefulWidget {
  const ShopkeeperHomeScreen({super.key});

  @override
  State<ShopkeeperHomeScreen> createState() => _ShopkeeperHomeScreenState();
}

class _ShopkeeperHomeScreenState extends State<ShopkeeperHomeScreen> {
  final authController = Get.find<AuthController>();
  final requestController = Get.put(RequestController());
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
                "Requests",
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
                        if (order.tag == authController.userModel!.tag) {
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
                                    try {
                                      await FirebaseMessaging.instance
                                          .subscribeToTopic("${request.tag}")
                                          .then((value) {
                                        debugPrint(
                                          "Status: Success!!!",
                                        );
                                      });
                                    } on Exception catch (e) {
                                      debugPrint("Error: $e");
                                    }
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
}
