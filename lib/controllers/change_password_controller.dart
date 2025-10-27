import 'package:chat_app/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController comfirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _obscureCurrentPassword = true.obs;
  final RxBool _obscureNewPassword = true.obs;
  final RxBool _obscureComfirmPassword = true.obs;

  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get obscureCurrentPassword => _obscureCurrentPassword.value;
  bool get obscureNewPassword => _obscureNewPassword.value;
  bool get obscureComfirmPassword => _obscureComfirmPassword.value;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    comfirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentPasswordVisibility() {
    _obscureCurrentPassword.value = !_obscureCurrentPassword.value;
  }

  void toggleNewPasswordVisibility() {
    _obscureNewPassword.value = !_obscureNewPassword.value;
  }

  void toggleComfirmPasswordVisibility() {
    _obscureComfirmPassword.value = !_obscureComfirmPassword.value;
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No User Logged In');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPasswordController.text);

      Get.snackbar(
        'Success',
        'Password Change Successfully',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: Duration(seconds: 3),
      );

      currentPasswordController.clear();
      newPasswordController.clear();
      comfirmPasswordController.clear();

      Get.back();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current Password is Incorrect';
          break;
        case 'weak-password':
          errorMessage = 'New Password is too weak';
          break;
        case 'requires-recent-login':
          errorMessage =
              'Please sign out and sign in again before change password';
          break;

        default:
          errorMessage = 'Faild To Change Password';
      }

      _error.value = errorMessage;
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: Duration(milliseconds: 4),
      );
    } catch (e) {
      _error.value = "Failed To Change Password";
      print(e.toString());
      Get.snackbar(
        'Error',
        _error.value,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: Duration(milliseconds: 4),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  String? valideteCurrentPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your current password';
    }
    return null;
  }

  String? valideteNewPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your a new password';
    }
    if (value!.length < 6) {
      return 'Password Must be atleast 6 charecters';
    }

    if (value == currentPasswordController.text) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? valideteComfirmPassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please comfirm your new password';
    }

    if (value != newPasswordController.text) {
      return 'Password Does Not March';
    }
    return null;
  }

  void clearError() {
    _error.value = '';
  }
}
