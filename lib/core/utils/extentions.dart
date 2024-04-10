import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ContextExtensions on BuildContext {
  Size get deviceSize => MediaQuery.sizeOf(this);
  Orientation get deviceOrientation => MediaQuery.orientationOf(this);
  void dissmissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

extension DateTimeExtentions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String toDate() {
    final formatter = DateFormat('MMM d, y');
    return formatter.format(this);
  }

  String toTime() {
    final formatter = DateFormat('hh:mm a');
    return formatter.format(this);
  }

  String getGreeting() {
    final hour = this.hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon!';
    } else if (hour >= 17 && hour < 20) {
      return 'Good Evening!';
    } else {
      return 'Night!';
    }
  }
}

extension ListRemoveDuplicates<E> on List<E> {
  List<E> removeDuplicates() {
    return toSet().toList();
  }
}

extension StringExtensions on String {
  String maskAll() {
    return "*" * 16;
  }

  String toQuantity() {
    String? formattedUnit;
    if (isEmpty) {
      throw Exception();
    }
    if (isNotEmpty) {
      formattedUnit = "$this Units";
    }
    return formattedUnit!;
  }

  String? validatePassword() {
    if (isEmpty) {
      return 'Please enter password';
    }
    if (trim().length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // format currency to Indian format
  String toCurrency() {
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    );
    return formatter.format(double.parse(this));
  }
}

extension IntExtentions on int {
  bool get isEven => this % 2 == 0;
  bool get isOdd => this % 2 != 0;
  String likeCounts() {
    if (this >= 1000000) {
      // Format for millions (e.g., 1.2m)
      double likesInMillions = this / 1000000.0;
      return '${likesInMillions.toStringAsFixed(1)}m';
    } else if (this >= 1000) {
      // Format for thousands (e.g., 1.2k)
      double likesInThousands = this / 1000.0;
      return '${likesInThousands.toStringAsFixed(1)}k';
    } else {
      // No formatting needed
      return toString();
    }
  }
}
