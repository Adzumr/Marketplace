import '../../models/welcome_model.dart';
import 'app_assets.dart';
import 'app_constants.dart';

class Helper {
  static List<IntroductionMessage> introductionMessges = [
    IntroductionMessage(
      image: AppAssets().logo,
      title: "Welcome to ${AppConstants().appName}!",
      subtitle:
          "Your one-stop destination for all your grocery needs. Discover a seamless shopping experience right at your fingertips",
    ),
    IntroductionMessage(
      image: AppAssets().logo,
      title: "Effortless Shopping Anytime, Anywhere",
      subtitle:
          "Browse through our extensive catalog, add items to your cart, and place orders with ease. Shop from the comfort of your home or on-the-go, whenever it suits you.",
    ),
    IntroductionMessage(
      image: AppAssets().logo,
      title: "Secure and Speedy Deliveries",
      subtitle:
          "Rest assured, your orders are processed securely, and deliveries are swift. Track your orders in real-time and receive them at your doorstep hassle-free.",
    ),
    IntroductionMessage(
      image: AppAssets().logo,
      title: "Get Started and Enjoy Shopping!",
      subtitle:
          "Join our community of shoppers to unlock exclusive deals and personalized recommendations. Sign up now or log in to dive into a world of convenience.",
    ),
  ];
}
