import 'package:flutter/material.dart';

import '../../models/product_model.dart';

/// A StatelessWidget that displays a card containing details of a request.
///
/// This widget is designed to present a single [RequestModel] within a visually
/// appealing card format. It also supports tap interaction through an optional callback.
///
/// Args:
///   key (Key?): The widget key that can be used to keep track of the widget's identity.
///   request (RequestModel): The request details to be displayed.
///   onPressed (VoidCallback?): An optional callback that is triggered when the card is tapped.
///
/// The widget uses the current theme context to style the card and text appropriately.
class RequestTile extends StatelessWidget {
  /// Constructs a [RequestTile] widget.
  ///
  /// Requires [request] to populate the card with content and an optional [onPressed]
  /// callback for tap functionality.
  const RequestTile({
    super.key,
    required this.request,
    required this.onPressed,
  });

  /// The data model containing the details of the request.
  final RequestModel request;

  /// An optional callback executed when the card is tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // Obtain the theme data from the current BuildContext to style the widget.
    final theme = Theme.of(context);

    return Card(
      // Set the background color of the card to the surface color of the current theme.
      color: theme.colorScheme.surface,
      // Define the shape of the card with rounded corners.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      // Vertical spacing around the card.
      margin: const EdgeInsets.symmetric(vertical: 10),
      // Padding inside the card.
      child: Padding(
        padding: const EdgeInsets.all(15),
        // Respond to tap events with an InkWell widget.
        child: InkWell(
          onTap: onPressed,
          // Layout the content in a column format.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display the name of the request.
              Text(
                request.name!,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              // Display the description of the request.
              Text(
                request.description!,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              // Display a tag or additional identifier for the request.
              Text(
                request.tag!,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
