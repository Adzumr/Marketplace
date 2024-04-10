import 'package:cached_network_image/cached_network_image.dart';
import 'package:marketplace/controllers/controllers/product_controller.dart';
import 'package:marketplace/core/routing/route_names.dart';
import 'package:marketplace/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  bool? isLoading = false;
  final productController = Get.find<ProductController>();

  getData() async {
    setState(() {
      isLoading = true;
    });
    productController.getProductsStream();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Get.toNamed(AppRouteNames.addProduct);
        },
      ),
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        leading: BackButton(
          color: theme.colorScheme.surface,
        ),
        centerTitle: true,
        title: Text(
          "Products",
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
            child: StreamBuilder<List<ProductModel>>(
              stream: productController.getProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<ProductModel> products = snapshot.data ?? [];
                  // Use the 'debtors' list to build your UI.
                  return products.isEmpty
                      ? Center(
                          child: Text(
                            "Empty",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = products[index];
                            return ProductTile(
                              product: product,
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

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () {
        Get.toNamed(
          AppRouteNames.product,
          arguments: product,
        );
      },
      leading: SizedBox(
        width: 50,
        child: Hero(
          tag: product.name!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: product.picture ?? "",
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
      title: Text(
        "${product.name}",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        "${product.description}",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: theme.textTheme.titleMedium,
      ),
      trailing: Text(
        "${product.price}",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}
