import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String userIdKey = "USER_ID_KEY";
  static const String userNameKey = "USER_NAME_KEY";
  static const String userEmailKey = "USER_EMAIL_KEY";
  static const String userImageKey = "USER_IMAGE_KEY";
  static const String userAgeKey = "USER_AGE_KEY";
  static const String userGenderKey = "USER_GENDER_KEY";

  // Save all user data in one call
  Future<bool> saveUserData({
    String? userId,
    String? userName,
    String? userEmail,
    String? userImage,
    String? userAge,
    String? userGender,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userId != null) await prefs.setString(userIdKey, userId);
      if (userName != null) await prefs.setString(userNameKey, userName);
      if (userEmail != null) await prefs.setString(userEmailKey, userEmail);
      if (userImage != null) await prefs.setString(userImageKey, userImage);
      if (userAge != null) await prefs.setString(userAgeKey, userAge);
      if (userGender != null) await prefs.setString(userGenderKey, userGender);
      return true;
    } catch (e) {
      print("Error saving user data: $e");
      return false;
    }
  }

  // Individual save methods (for specific updates)
  Future<bool> saveUserId(String? userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userId != null) {
        return await prefs.setString(userIdKey, userId);
      } else {
        await prefs.remove(userIdKey);
        return true;
      }
    } catch (e) {
      print("Error saving user ID: $e");
      return false;
    }
  }

  Future<bool> saveUserName(String? userName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userName != null) {
        return await prefs.setString(userNameKey, userName);
      } else {
        await prefs.remove(userNameKey);
        return true;
      }
    } catch (e) {
      print("Error saving user name: $e");
      return false;
    }
  }

  Future<bool> saveUserEmail(String? userEmail) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userEmail != null) {
        return await prefs.setString(userEmailKey, userEmail);
      } else {
        await prefs.remove(userEmailKey);
        return true;
      }
    } catch (e) {
      print("Error saving user email: $e");
      return false;
    }
  }

  Future<bool> saveUserImage(String? userImage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userImage != null) {
        return await prefs.setString(userImageKey, userImage);
      } else {
        await prefs.remove(userImageKey);
        return true;
      }
    } catch (e) {
      print("Error saving user image: $e");
      return false;
    }
  }

  Future<bool> saveUserAge(String? userAge) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userAge != null) {
        return await prefs.setString(userAgeKey, userAge);
      } else {
        await prefs.remove(userAgeKey);
        return true;
      }
    } catch (e) {
      print("Error saving user age: $e");
      return false;
    }
  }

  Future<bool> saveUserGender(String? userGender) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userGender != null) {
        return await prefs.setString(userGenderKey, userGender);
      } else {
        await prefs.remove(userGenderKey);
        return true;
      }
    } catch (e) {
      print("Error saving user gender: $e");
      return false;
    }
  }

  // Get methods
  Future<String?> getUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userIdKey);
    } catch (e) {
      print("Error retrieving user ID: $e");
      return null;
    }
  }

  Future<String?> getUserName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userNameKey);
    } catch (e) {
      print("Error retrieving user name: $e");
      return null;
    }
  }

  Future<String?> getUserEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userEmailKey);
    } catch (e) {
      print("Error retrieving user email: $e");
      return null;
    }
  }

  Future<String?> getUserImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userImageKey);
    } catch (e) {
      print("Error retrieving user image: $e");
      return null;
    }
  }

  Future<String?> getUserAge() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userAgeKey);
    } catch (e) {
      print("Error retrieving user age: $e");
      return null;
    }
  }

  Future<String?> getUserGender() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userGenderKey);
    } catch (e) {
      print("Error retrieving user gender: $e");
      return null;
    }
  }

  // Clear user data (for logout)
  Future<bool> clearUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all preferences (more thorough cleanup)
      return true;
    } catch (e) {
      print("Error clearing user data: $e");
      return false;
    }
  }
}