import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers/auth_controller.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/themes.dart';
import '../../../core/utils/app_constants.dart';
import '../../widgets/app_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authController = Get.find<AuthController>();
  final fullNameController = TextEditingController();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool? isSecure = true;
  bool? isConfirmSecure = true;
  bool? shopkeeper = false;
  bool? isLoading = false;
  String? selectedRole;
  String? selectedTag;
  List<DropdownMenuItem<String>> roles = const [
    DropdownMenuItem(
      value: 'customer',
      child: Text('Customer'),
    ),
    DropdownMenuItem(
      value: 'shopkeeper',
      child: Text('Shopkeeper'),
    ),
  ];
  List<DropdownMenuItem<String>> tags = const [
    DropdownMenuItem(
      value: 'tag1',
      child: Text('Tag 1'),
    ),
    DropdownMenuItem(
      value: 'tag2',
      child: Text('Tag 2'),
    ),
    DropdownMenuItem(
      value: 'tag3',
      child: Text('Tag 3'),
    ),
  ];
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
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppLogo(
                          height: 150,
                        ),
                        const SizedBox(height: 36),
                        Text(
                          "Join ${AppConstants().appName} Today!",
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: emailAddressController,
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
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: fullNameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Full Name",
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
                          style: theme.textTheme.bodyMedium!,
                          items: roles,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value;
                            });
                          },
                          hint: Text(
                            'Select Role',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        selectedRole == "shopkeeper"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DropdownButtonFormField<String>(
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
                                    hint: Text(
                                      'Select Tag',
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              )
                            : const SizedBox.shrink(),
                        TextFormField(
                          obscureText: isSecure!,
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isSecure == true) {
                                    isSecure = false;
                                  } else {
                                    isSecure = true;
                                  }
                                });
                              },
                              icon: Icon(
                                isSecure! == false
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            context.dissmissKeyboard();
                            if (formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                await authController.registerUser(
                                  emailAddress:
                                      emailAddressController.text.trim(),
                                  password: passwordController.text.trim(),
                                  fullName: fullNameController.text.trim(),
                                  tag: "tag1",
                                  role: selectedRole,
                                );
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: const Text(
                            "Register",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Get.offNamed(AppRouteNames.login);
                          },
                          child: const Text(
                            "Already have an account?",
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
