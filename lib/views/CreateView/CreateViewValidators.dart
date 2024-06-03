class CreateViewValidators {
  static String? aliasValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alias is empty';
    } else if (value.length < 5) {
      return 'Alias must contain 5 characters';
    }

    return null;
  }

  static String? urlValidator(String? value) {

    if (value == null || value.isEmpty) {
      return 'Url is empty';
    } else if (!Uri.parse(value).isAbsolute) {
      return 'Url invalid';
    }

    return null;
  }

  static String? periodValidator(String? value, typePeriod) {

    if (value == null || value.isEmpty) {
      return 'Period is empty';
    }

    int factor = 1;

    if (typePeriod == "Days") {
      factor = 24;
    } else if (typePeriod == "Weeks") {
      factor = 168;
    }

    int numberValue = int.parse(value);

    if (numberValue == 0) {
      return 'The period must be greater than 0';
    } else if (numberValue*factor == 672) {
      return 'The period must be less than 4 weeks';
    }

    return null;
  }

}