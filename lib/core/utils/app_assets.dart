/// create a class for app constants  usinhg signleton pattern
///
class AppAssets {
  static final AppAssets instance = AppAssets._internal();

  factory AppAssets() {
    return instance;
  }

  AppAssets._internal();
  final String noNetworkAnim = "assets/network.json";
  final String logo = "assets/logo.png";
}
