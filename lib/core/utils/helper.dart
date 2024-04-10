import '../../models/welcome_model.dart';
import 'app_assets.dart';
import 'app_constants.dart';

class Helper {
  static List<IntroductionMessage> introductionMessges = [
    IntroductionMessage(
      image: AppAssets().logo,
      title: "Welcome to ${AppConstants().appName}!",
      subtitle:
          "Explore a new way to connect with customers and shopkeepers seamlessly.",
    ),
    IntroductionMessage(
      image: AppAssets().logo,
      title: "How ${AppConstants().appName} Works",
      subtitle:
          "Post your requirements, and let shopkeepers respond based on your preferences. Shopkeepers, create your profile and receive notifications for matching customer requirements.",
    ),
    IntroductionMessage(
      image: AppAssets().logo,
      title: "Why Choose ${AppConstants().appName}?",
      subtitle:
          "Find what you need, when you need it. Streamline your shopping experience and reach potential customers effortlessly.",
    ),
    IntroductionMessage(
      image: AppAssets().logo,
      title: "Let's Get Started!",
      subtitle:
          "Start connecting with customers or shopkeepers today. Register or log in to begin.",
    ),
  ];
}
