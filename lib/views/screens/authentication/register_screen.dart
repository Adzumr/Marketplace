import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers/auth_controller.dart';
import '../../../core/routing/route_names.dart';
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
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool? isSecure = true;
  bool? isConfirmSecure = true;
  bool? isLoading = false;

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
                        const SizedBox(height: 10),
                        Text(
                          "Create your account to unlock exciting offers, track your orders, and enjoy a personalized shopping experience.",
                          style: theme.textTheme.bodyLarge,
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
                            prefixIcon: Icon(
                              Icons.email_outlined,
                            ),
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
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: addressController,
                          keyboardType: TextInputType.streetAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Address";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Address",
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 11,
                          onChanged: (value) {
                            if (value.trim().length >= 11) {
                              context.dissmissKeyboard();
                            }
                          },
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Enter Mobile Number";
                            }
                            if (value.length < 11) {
                              return "Invalid Number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Mobile Number",
                            counterText: "",
                            prefixIcon: Icon(
                              Icons.phone_android_outlined,
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: isConfirmSecure!,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Confirm Password";
                            }
                            if (value.trim() !=
                                passwordController.text.trim()) {
                              return "Password do not match";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isConfirmSecure == true) {
                                    isConfirmSecure = false;
                                  } else {
                                    isConfirmSecure = true;
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
                                      await authController.registerUser(
                                        emailAddress:
                                            emailAddressController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        fullName:
                                            fullNameController.text.trim(),
                                        phoneNumber:
                                            phoneNumberController.text.trim(),
                                        address: addressController.text.trim(),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
