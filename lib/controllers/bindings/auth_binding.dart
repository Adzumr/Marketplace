import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// AuthBinding is a class that extends the Bindings class to manage dependency injection
/// for authentication-related controllers within the app.
///
/// It is part of the GetX package's dependency injection and state management solution.
/// This class specifically manages the lifecycle of the AuthController by ensuring it
/// is lazily instantiated when needed.
class AuthBinding extends Bindings {
  /// This method is an override of the dependencies method in the Bindings superclass.
  /// It sets up the dependencies that will be required by other parts of the application.
  ///
  /// Inside this method, the AuthController is lazily put into the dependency injection container.
  /// This means that the AuthController will not be instantiated until it is actually needed,
  /// and it will be disposed when it is no longer in use, helping to manage resources efficiently.
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(), // Creates an instance of AuthController
    );
  }
}
