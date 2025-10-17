import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _comfirmPasswordController = TextEditingController();

  final AuthController _authController = Get.find<AuthController>();
  bool _obsecurePassword = true;
  bool _obsecureComfirmPassword = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _comfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back),
                    ),
                    Text(
                      "Create Account",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Fill in your details to get started",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Enter your Name',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Enter your email',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obsecurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    hintText: 'Enter your Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obsecurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obsecurePassword = !_obsecurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _comfirmPasswordController,
                  obscureText: _obsecureComfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Comfirm Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    hintText: 'Comfirm your Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obsecureComfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obsecureComfirmPassword = !_obsecureComfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please comfirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _authController.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _authController.registerWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                  _displayNameController.text,
                                );
                              }
                            },
                      child: _authController.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text("Create Account"),
                    ),
                  ),
                ),
                // SizedBox(height: 16),
                // Center(
                //   child: TextButton(
                //     onPressed: () {
                //       Get.toNamed(AppRoutes.forgotPassword);
                //     },
                //     child: Text(
                //       'Forgot Password',
                //       style: TextStyle(color: AppTheme.primaryColor),
                //     ),
                //   ),
                // ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppTheme.borderColor)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(child: Divider(color: AppTheme.borderColor)),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
