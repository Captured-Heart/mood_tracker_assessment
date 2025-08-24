
// check if the email is valid
final RegExp emailRegex = RegExp(
  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
);
final RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~]).+$');

class AppValidations {
  const AppValidations._();

  static String? validatedName(String? value, {String label = "Name"}) {
    String? result;
    if (value != null && value.trim().isEmpty) {
      result = "$label can't be empty";
    } else {
      result = null;
    }

    return result;
  }

  static String? validatedEmail(String? value) {
    String? result;
    if (value != null) {
      if (value.trim().isEmpty) {
        result = "Email cannot be empty";
      } else if (!emailRegex.hasMatch(value)) {
        result = "Invalid email";
      }
    } else {
      result = null;
    }
    return result;
  }

  static String? validatePassword(String? password) {
    // Check if the password is null or empty
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    // Validate the password
    if (!passwordRegex.hasMatch(password)) {
      return 'Password must contain at least \none capital letter and one special character';
    }

    // If everything is fine, return null (no error)
    return null;
  }
}
