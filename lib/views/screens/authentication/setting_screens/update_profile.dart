import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:marketplace/controllers/controllers/auth_controller.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
    phoneNumber = TextEditingController(text: authController.userModel!.phone);
    address = TextEditingController(text: authController.userModel!.tag);
    super.initState();
  }

  TextEditingController? emailAddress;
  TextEditingController? fullName;
  TextEditingController? phoneNumber;
  TextEditingController? address;
  final authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  bool? isLoading = false;
  XFile? pickedFile;
  Future getPhoto({ImageSource? imageSource}) async {
    final ImagePicker picker = ImagePicker();

    // Pick an image from gallery
    pickedFile = await picker.pickImage(
      source: imageSource!,
      maxHeight: 500,
      maxWidth: 500,
    );
    setState(() {});
    if (pickedFile != null) {
      debugPrint(pickedFile!.name);
    }
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
                pickedFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () async {
                            await getPhoto(
                              imageSource: ImageSource.gallery,
                            );
                          },
                          child: Image(
                            image: FileImage(
                              File(pickedFile!.path),
                            ),
                            alignment: Alignment.center,
                            height: 200,
                            // width: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: authController.userModel!.picture ?? "",
                          height: 200,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return Column(
                              children: [
                                const Icon(
                                  Icons.camera_outlined,
                                  size: 100,
                                ),
                                IconButton(
                                  onPressed: () {
                                    getPhoto(imageSource: ImageSource.gallery);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                )
                              ],
                            );
                          },
                          placeholder: (context, url) {
                            return const Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 10),
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
                      TextFormField(
                        controller: address,
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
                        controller: phoneNumber,
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
                      const SizedBox(height: 40),
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
                                imageFile: pickedFile,
                                name: fullName!.text.trim(),
                                address: address!.text.trim(),
                                phone: phoneNumber!.text.trim(),
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
