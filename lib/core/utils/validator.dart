

import 'package:clean_arch/core/localization/locale_keys.dart';
import 'package:flutter/cupertino.dart';

abstract class Validation<T> {
  const Validation();

  String? validate(T? value, FocusNode focusNode);
}

class RequiredValidation<T> extends Validation<T> {
  @override
  String? validate(T? value, FocusNode focusNode) {
    if (value == null || (value is String && value.isEmpty)) {
      return LocaleKeys.requiredField;
    }
    return null;
  }
}

class EmailValidation extends Validation<String> {
  @override
  String? validate(String? value, FocusNode focusNode) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value == null) return null;

    if (!emailRegex.hasMatch(value)) {
      return LocaleKeys.invalidEmail;
    }
    return null;
  }
}

class PhoneValidation extends Validation<String> {
  const PhoneValidation();

  @override
  String? validate(String? value, FocusNode focusNode) {
    final phoneRegex = RegExp(r'^(010|011|012|015)\d{8}$');

    if (value == null) return null;

    if (!phoneRegex.hasMatch(value)) {
      return LocaleKeys.phoneNumber;
    }
    return null;
  }
}

class PasswordValidation extends Validation<String> {
  @override
  String? validate(String? value, FocusNode focusNode) {
    if (value == null) return null;

    if (value.length < 6) {
      return LocaleKeys.invalidEmail;
    }
    return null;
  }
}

class NameValidation extends Validation<String> {
  @override
  String? validate(String? value, FocusNode focusNode) {
    if (value == null) return null;
    if (value.length < 3) {
      return LocaleKeys.firstName;
    }
    return null;
  }
}

class GuestValidation extends Validation<String> {
  @override
  String? validate(String? value, FocusNode focusNode) {
    if (value == 'guest') {
      return LocaleKeys.firstName;
    } else {
      return null;
    }
  }
}

class NumberValidation extends Validation<String> {
  @override
  String? validate(String? value, FocusNode focusNode) {
    if (value == null) return null;
    if (value.isEmpty) {
      return LocaleKeys.requiredField;
    }
    return null;
  }
}

class OtpCodeValidation extends Validation<String> {
  @override
  String? validate(String? value, FocusNode focusNode) {
    if (value == null) return null;

    if (value.length != 5) {
      focusNode.requestFocus();
      return LocaleKeys.otpCodeMissing;
    }
    return null;
  }
}

class Validator {
  Validator._();

  static FormFieldValidator<T> apply<T>(
    List<Validation<T>> validations,
    FocusNode focusNode,
  ) {
    return (value) {
      for (final validation in validations) {
        final error = validation.validate(value, focusNode);
        if (error != null) return error;
      }
      return null;
    };
  }
}

String? validateField({
  required String value,
  required List<Validation<String>> validations,
  required FocusNode focusNode,
}) {
  for (final validation in validations) {
    final error = validation.validate(value, focusNode);
    if (error != null) {
      return error;
    }
  }
  return null;
}
