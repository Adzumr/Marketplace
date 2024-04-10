import 'package:cached_network_image/cached_network_image.dart';
import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/core/utils/app_constants.dart';
import 'package:marketplace/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  bool? isLoading = false;
  final dishController = Get.find<AuthController>();

  getData() async {
    setState(() {
      isLoading = true;
    });
    dishController.getUsersStream();
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
          "Customers",
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
            child: StreamBuilder<List<UserModel>>(
              stream: dishController.getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<UserModel> customers = snapshot.data ?? [];
                  // Use the 'debtors' list to build your UI.
                  return customers.isEmpty
                      ? Center(
                          child: Text(
                            "No Customer",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )
                      : ListView.builder(
                          itemCount: customers.length,
                          itemBuilder: (BuildContext context, int index) {
                            final customer = customers[index];
                            return CustomerTile(
                              customer: customer,
                            );
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

class CustomerTile extends StatelessWidget {
  const CustomerTile({
    super.key,
    required this.customer,
  });
  final UserModel customer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () {
        showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: Text(
                "Customer Detail",
                style: theme.textTheme.titleLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: SizedBox(
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: customer.picture ?? "",
                          height: 50,
                          width: 50,
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
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Name",
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "${customer.name}",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Contact",
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "${customer.phone}",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Email",
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "${customer.email}",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Address",
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "${customer.address}",
                      style: theme.textTheme.bodyLarge,
                    ),
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
          },
        );
      },
      leading: SizedBox(
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: customer.picture ?? "",
            height: 50,
            width: 50,
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
      ),
      title: Text(
        "${customer.name}",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        "${customer.email}",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: theme.textTheme.titleMedium,
      ),
      trailing: IconButton.filledTonal(
        onPressed: () {
          try {
            AppConstants().makeCall(
              telephoneNumber: customer.phone,
            );
          } on Exception catch (e) {
            debugPrint("Error: $e");
            AppConstants().throwError("$e");
          }
        },
        icon: const Icon(
          Icons.call,
        ),
      ),
    );
  }
}
