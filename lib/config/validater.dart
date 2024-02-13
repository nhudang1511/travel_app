import '../travel/screen/card/components/card_util.dart';

const String notEmptyError = "This field cannot be empty.";
const String fieldNotValidError = "This field is not valid.";

String? validateName(String? value) {
  if (value!.isEmpty) {
    return notEmptyError;
  }
  if (value.length < 3) {
    return 'Name must be more than 2 character';
  } else {
    return null;
  }
}

String? validateEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (value!.isEmpty) {
    return notEmptyError;
  }
  if (!regex.hasMatch(value)) {
    return fieldNotValidError;
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  if (value!.isEmpty) {
    return "Password is not empty";
  }
  return null;
}

String? validateCountry(String? country) {
  if (country!.isEmpty) {
    return "Name can't be empty";
  }
  return null;
}

String? validatePhone(String? phone) {
  if (phone!.isEmpty) {
    return "Phone can't be empty";
  }
  return null;
}

String? validateCVV(String? value) {
  if (value!.isEmpty) {
    return "CVV can't be empty";
  }

  if (value.length < 3 || value.length > 4) {
    return "CVV is invalid";
  }
  return null;
}
String? validateCardNum(String? input) {
  if (input == null || input.isEmpty) {
    return "card number can't be empty";
  }

  input = CardUtil.getCleanedNumber(input);

  if (input.length < 8) {
    return "card number cannot be less than 8";
  }

  int sum = 0;
  int length = input.length;
  for (var i = 0; i < length; i++) {
    // get digits in reverse order
    int digit = int.parse(input[length - i - 1]);

    // every 2nd number multiply with 2
    if (i % 2 == 1) {
      digit *= 2;
    }
    sum += digit > 9 ? (digit - 9) : digit;
  }

  if (sum % 10 == 0) {
    return null;
  }

  return "Card number is not valid";
}

String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return "Date can't be empty";
  }

  int year;
  int month;
// The value contains a forward slash if the month and year has been
// entered.
  if (value.contains(RegExp(r'(/)'))) {
    var split = value.split(RegExp(r'(/)'));
// The value before the slash is the month while the value to right of
// it is the year.
    month = int.parse(split[0]);
    year = int.parse(split[1]);
  } else {
// Only the month was entered
    month = int.parse(value.substring(0, (value.length)));
    year = -1; // Lets use an invalid year intentionally
  }

  if ((month < 1) || (month > 12)) {
// A valid month is between 1 (January) and 12 (December)
    return 'Expiry month is invalid';
  }

  var fourDigitsYear = convertYearTo4Digits(year);
  if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
// We are assuming a valid should be between 1 and 2099.
// Note that, it's valid doesn't mean that it has not expired.
    return 'Expiry year is invalid';
  }

  if (!hasDateExpired(month, year)) {
    return "Card has expired";
  }
  return null;
}

int convertYearTo4Digits(int year) {
  if (year < 100 && year >= 0) {
    var now = DateTime.now();
    String currentYear = now.year.toString();
    String prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}

bool hasDateExpired(int month, int year) {
  return isNotExpired(year, month);
}

bool isNotExpired(int year, int month) {
  // It has not expired if both the year and date has not passed
  return !hasYearPassed(year) && !hasMonthPassed(year, month);
}

bool hasMonthPassed(int year, int month) {
  var now = DateTime.now();
  // The month has passed if:
  // 1. The year is in the past. In that case, we just assume that the month
  // has passed
  // 2. Card's month (plus another month) is more than current month.
  return hasYearPassed(year) ||
      convertYearTo4Digits(year) == now.year && (month < now.month + 1);
}

bool hasYearPassed(int year) {
  int fourDigitsYear = convertYearTo4Digits(year);
  var now = DateTime.now();
  // The year has passed if the year we are currently is more than card's
  // year
  return fourDigitsYear < now.year;
}
