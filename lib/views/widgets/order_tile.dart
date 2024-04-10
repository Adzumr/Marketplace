import 'package:marketplace/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/models/my_order_model.dart';

import '../../core/routing/route_names.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
  });

  final MyOrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () {
        Get.toNamed(
          AppRouteNames.order,
          arguments: order,
        );
      },
      leading: IconButton.filled(
        onPressed: () {},
        icon: const Icon(
          Icons.shopping_bag_outlined,
        ),
      ),
      //  SizedBox(
      //   height: 50,
      //   width: 50,
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(15),
      //     child: CachedNetworkImage(
      //       imageUrl: order.dishPic ?? "",
      //       height: 50,
      //       width: 50,
      //       fit: BoxFit.fill,
      //       placeholder: (context, url) {
      //         return const Center(
      //           child: CircularProgressIndicator.adaptive(),
      //         );
      //       },
      //       errorWidget: (context, url, error) {
      //         return const Icon(
      //           Icons.account_circle_outlined,
      //           size: 40,
      //         );
      //       },
      //     ),
      //   ),
      // ),
      title: Text(
        "${order.date}",
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        "${order.items!.length} item(s)",
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: Text(
        "${order.totalAmount}".toCurrency(),
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}
