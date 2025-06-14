import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String userIdKey = "USER_ID_KEY";
  static String userNameKey = "USER_NAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";
  static String userImageKey = "USER_IMAGE_KEY";
  static String userAgeKey = "USER_AGE_KEY";
  static String userGenderKey = "USER_GENDER_KEY";

  // Save user ID
  Future<bool> saveUserId(String getUserID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(userIdKey, getUserID);
    } catch (e) {
      print("Error saving user ID: $e");
      return false;
    }
  }

  // Save user name
  Future<bool> saveUserName(String getUserName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(userNameKey, getUserName);
    } catch (e) {
      print("Error saving user name: $e");
      return false;
    }
  }

  // Save user email
  Future<bool> saveUserEmail(String getUserEmail) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(userEmailKey, getUserEmail);
    } catch (e) {
      print("Error saving user email: $e");
      return false;
    }
  }

  // Save user image
  Future<bool> saveUserImage(String getUserImage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(userImageKey, getUserImage);
    } catch (e) {
      print("Error saving user image: $e");
      return false;
    }
  }

  // Save user age
  Future<bool> saveUserAge(String getUserAge) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(userAgeKey, getUserAge);
    } catch (e) {
      print("Error saving user age: $e");
      return false;
    }
  }

  // Save user gender
  Future<bool> saveUserGender(String getUserGender) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(userGenderKey, getUserGender);
    } catch (e) {
      print("Error saving user gender: $e");
      return false;
    }
  }

  // Get user ID
  Future<String?> getUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userIdKey);
    } catch (e) {
      print("Error retrieving user ID: $e");
      return null;
    }
  }

  // Get user name
  Future<String?> getUserName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userNameKey);
    } catch (e) {
      print("Error retrieving user name: $e");
      return null;
    }
  }

  // Get user email
  Future<String?> getUserEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userEmailKey);
    } catch (e) {
      print("Error retrieving user email: $e");
      return null;
    }
  }

  // Get user image
  Future<String?> getUserImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userImageKey);
    } catch (e) {
      print("Error retrieving user image: $e");
      return null;
    }
  }

  // Get user age
  Future<String?> getUserAge() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(userAgeKey);
    } catch (e) {
      print("Error retrieving user age: $e");
      return null;
    }
  }

  // Get user gender
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
      await prefs.remove(userIdKey);
      await prefs.remove(userNameKey);
      await prefs.remove(userEmailKey);
      await prefs.remove(userImageKey);
      await prefs.remove(userAgeKey);
      await prefs.remove(userGenderKey);
      return true;
    } catch (e) {
      print("Error clearing user data: $e");
      return false;
    }
  }
}