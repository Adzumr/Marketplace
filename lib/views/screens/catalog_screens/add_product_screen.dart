import 'dart:io';

import 'package:marketplace/controllers/controllers/product_controller.dart';
import 'package:marketplace/core/utils/extentions.dart';
import 'package:marketplace/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/app_constants.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final price = TextEditingController();
  final name = TextEditingController();
  final description = TextEditingController();
  final controller = Get.find<ProductController>();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Add Product",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
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
                        child: IconButton(
                          onPressed: () {
                            getPhoto(imageSource: ImageSource.gallery);
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            size: 120,
                          ),
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
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: price,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Price";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Price",
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
                          if (pickedFile == null) {
                            return AppConstants().throwError("Add Picture");
                          }
                          if (formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              final product = ProductModel(
                                description: description.text.trim(),
                                name: name.text.trim(),
                                price: double.tryParse(price.text.trim()),
                              );
                              await controller.addProduct(
                                dishImage: pickedFile,
                                dish: product,
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Add Product",
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
