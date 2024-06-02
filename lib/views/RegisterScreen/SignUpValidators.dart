class SignUpValidators {
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is empty';
    } else if (value.length < 5) {
      return 'Username must contain 5 characters';
    }

    return null;
  }

  static String? emailValidator(String? value) {

    const expression = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

    if (value == null || value.isEmpty) {
      return 'Email is empty';
    } else if (!RegExp(expression).hasMatch(value)) {
      return 'Email invalid';
    }

    return null;
  }

  static String? passwordValidator(String? value) {

    if (value == null || value.isEmpty) {
      return 'Password is empty';
    } else if (value.length < 5) {
      return 'Password must contain 5 characters';
    }

    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {

    if (value != password) {
      return 'Password does not match';
    }

    return null;
  }
}