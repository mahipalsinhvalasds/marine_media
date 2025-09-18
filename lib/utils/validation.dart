class CustomValidations {
  static String? nullValidator(String? value, {String? customMessage}) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'Please enter a value';
    }
    return null;
  }

  static String? intNullValidator(int? value, {String? customMessage}) {
    if (value == null || value.toString().isEmpty) {
      return customMessage ?? 'Please enter a value';
    }
    return null;
  }

  static String? emailValidator(String? value, {String? customMessage}) {
    final nullValidationResult =
    nullValidator(value, customMessage: customMessage);
    if (nullValidationResult != null) {
      return customMessage ?? 'Please enter an email address';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!)) {
      return customMessage ?? 'Please enter a valid email address';
    }
    return null;
  }

  static String? passwordValidator(String? value, {String? customMessage}) {
    final nullValidationResult =
    nullValidator(value, customMessage: customMessage);
    if (nullValidationResult != null) {
      return customMessage ?? 'Please enter a password';
    }

    if (value!.length < 8) {
      return customMessage ?? 'Password must be at least 8 characters long';
    }
    return null;
  }

  static String? phoneValidator(String? value, {String? customMessage}) {
    final nullValidationResult =
    nullValidator(value, customMessage: customMessage);
    if (nullValidationResult != null) {
      return customMessage ?? 'Please enter a phone number';
    }

    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value!)) {
      return customMessage ?? 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? postalCodeValidator(String? value, {String? customMessage}) {
    final nullValidationResult =
    nullValidator(value, customMessage: customMessage);
    if (nullValidationResult != null) {
      return customMessage ?? 'Please enter a postal code';
    }

    // Example regex for a 5-6 digit postal code, modify for regional requirements
    final postalCodeRegex = RegExp(r'^\d{5,6}$');
    if (!postalCodeRegex.hasMatch(value!)) {
      return customMessage ?? 'Please enter a valid postal code';
    }
    return null;
  }
}
