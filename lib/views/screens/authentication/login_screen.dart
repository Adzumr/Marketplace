import 'package:marketplace/core/utils/app_constants.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/controllers/auth_controller.dart';
import '../../../core/routing/route_names.dart';
import '../../widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.find<AuthController>();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool? isSecure = true;
  bool? isConfirmSecure = true;
  bool? isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                            "Welcome Back to ${AppConstants().appName}!",
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Log in to your account to continue shopping and manage your orders effortlessly.",
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: emailAddressController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Username";
                              }
                              if (!value.trim().isEmail) {
                                return "Invalid Email Address";
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
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                              ),
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
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                              await authController.loginUser(
                                email: emailAddressController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Login",
                        ),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Get.offNamed(AppRouteNames.register);
                  },
                  child: const Text(
                    "Don't have Account? Sign up now!",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
