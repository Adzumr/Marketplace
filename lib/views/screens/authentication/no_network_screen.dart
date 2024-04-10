import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/app_assets.dart';

class NoNetworkScreen extends StatefulWidget {
  final FlutterErrorDetails? error;
  const NoNetworkScreen({this.error, super.key});

  @override
  State<NoNetworkScreen> createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Lottie.asset(
                  AppAssets().noNetworkAnim,
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    "Please check your Internet connection",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
