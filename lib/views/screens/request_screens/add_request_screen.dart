import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/controllers/controllers/request_controller.dart';
import 'package:marketplace/core/utils/enums.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:marketplace/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/models/user_model.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/themes.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final name = TextEditingController();
  final description = TextEditingController();
  final controller = Get.find<RequestController>();
  final authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  List<UserModel> users = [];
  getUsers() async {
    users.clear();
    users = await authController.getUsers();
    for (var user in users) {
      if (user.role == Roles.shopkeeper.name && user.tag == selectedTag) {
        debugPrint("Token: ${user.token}");
      }
    }
  }

  bool? isLoading = false;
  String? selectedTag = "tag1";
  List<DropdownMenuItem<String>> tags = [
    DropdownMenuItem(
      value: 'tag1',
      child: Row(
        children: [
          Icon(
            Icons.security_outlined,
            color: AppColor().primary,
          ),
          const SizedBox(width: 16),
          const Text('Tag 1'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 'tag2',
      child: Row(
        children: [
          Icon(
            Icons.security_outlined,
            color: AppColor().primary,
          ),
          const SizedBox(width: 16),
          const Text('Tag 2'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 'tag3',
      child: Row(
        children: [
          Icon(
            Icons.security_outlined,
            color: AppColor().primary,
          ),
          const SizedBox(width: 16),
          const Text('Tag 3'),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    getUsers();
                  },
                  child: Text(
                    "Add Request",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: name,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Product name";
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Name",
                            prefixIcon: Icon(
                              Icons.topic_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: description,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Enter Description";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Description",
                            prefixIcon: Icon(
                              Icons.note_alt_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            enabledBorder: enabledInputBorder,
                            errorBorder: errorInputBorder,
                            disabledBorder: outlinedInputBorder,
                            focusedBorder: enabledInputBorder,
                          ),
                          items: tags,
                          style: theme.textTheme.bodyMedium,
                          onChanged: (value) async {
                            setState(() {
                              selectedTag = value;
                              debugPrint("Tag: $value");
                            });
                            await getUsers();
                          },
                          hint: Row(
                            children: [
                              Icon(
                                Icons.security_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Select Tag',
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            context.dissmissKeyboard();
                            await createRequest();
                          }
                        },
                        child: const Text(
                          "Add Request",
                        ),
                      ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createRequest() async {
    try {
      setState(() {
        isLoading = true;
      });
      final product = RequestModel(
        tag: selectedTag,
        customerId: authController.userModel!.id,
        description: description.text.trim(),
        name: name.text.trim(),
      );

      if (selectedTag != null) {
        await controller.addRequest(
          request: product,
        );
        for (var user in users) {
          if (user.role == Roles.shopkeeper.name && user.tag == selectedTag) {
            debugPrint("Token: ${user.token}");
            await controller.sendNotification(
              token: user.token!,
            );
          }
        }
      } else {
        Get.snackbar(
          "Choose Tag",
          "Select Tag before submitting Tag",
        );
      }
    } finally {
      setState(() {
        isLoading = false;
        Get.back();
      });
    }
  }
}
