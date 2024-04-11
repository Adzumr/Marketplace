import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/core/utils/enums.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/themes.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  void initState() {
    emailAddress = TextEditingController(text: authController.userModel!.email);
    fullName = TextEditingController(text: authController.userModel!.name);
    role = TextEditingController(text: authController.userModel!.role);
    selectedTag = authController.userModel!.tag;
    super.initState();
  }

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

  String? selectedTag;
  TextEditingController? emailAddress;
  TextEditingController? fullName;
  TextEditingController? role;
  final authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  bool? isLoading = false;

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
          "Update Profile",
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.surface,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: emailAddress,
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email Address";
                          }
                          if (!value.trim().isEmail) {
                            return "Invalid email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                          prefixIcon: Icon(
                            Icons.email_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: fullName,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Name";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: Icon(
                            Icons.person_outline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      authController.userModel!.role == Roles.customer.name
                          ? const SizedBox.shrink()
                          : DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                enabledBorder: enabledInputBorder,
                                errorBorder: errorInputBorder,
                                disabledBorder: outlinedInputBorder,
                                focusedBorder: enabledInputBorder,
                              ),
                              items: tags,
                              style: theme.textTheme.bodyMedium,
                              onChanged: (value) {
                                setState(() {
                                  selectedTag = value;
                                });
                              },
                              hint: Row(
                                children: [
                                  Icon(
                                    Icons.security_outlined,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    selectedTag!,
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                )),
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          context.dissmissKeyboard();
                          if (formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              await authController.updateUser(
                                name: fullName!.text.trim(),
                                tag: authController.userModel!.role ==
                                        Roles.customer.name
                                    ? ""
                                    : selectedTag,
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Update",
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
}
