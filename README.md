# Flutter Marketplace App

This Flutter app is designed to create a marketplace where customers can post their requirements and shopkeepers can respond based on predefined tags associated with their profiles.

## Features

- **User Authentication**: Implemented login system for both customers and shopkeepers using Firebase Authentication.
- **Customer Requirement Form**: Allows customers to fill out a form specifying their requirements with predefined tags.
- **Shopkeeper Profile Creation**: Enables shopkeepers to create profiles including business details and associated tags.
- **Tagged Preferences**: Shopkeepers can associate predefined tags with their profiles to match customer requirements.
- **Notification System**: Push notifications are sent to shopkeepers when a customer's requirement matches their tagged preferences using Firebase Cloud Messaging.
- **Matching Algorithm**: Developed an algorithm to match customer requirements with shopkeepers' tagged preferences.
- **Simple Frontend Implementation**: Intuitive form for data input, responsive layout, and straightforward educational entries management.

## Technologies Used

- **Flutter**: Used for building the mobile application's frontend.
- **Firebase**: Leveraged Firebase Authentication for user authentication and Firebase Firestore for storing requirement and profile data.
- **GetX**: Implemented MVC architecture for state management and business logic organization.
