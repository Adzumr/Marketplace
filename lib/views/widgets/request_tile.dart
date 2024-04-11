import 'package:flutter/material.dart';

import '../../models/product_model.dart';

class RequestTile extends StatelessWidget {
  const RequestTile({
    super.key,
    required this.request,
    required this.onPressed,
  });

  final RequestModel request;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${request.name}",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "${request.tag}",
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "${request.description}",
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
