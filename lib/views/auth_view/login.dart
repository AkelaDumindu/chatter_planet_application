import 'package:chatter_planet_application/services/auth/auth_service.dart';
import 'package:chatter_planet_application/utilz/colors.dart';
import 'package:chatter_planet_application/widget/reusable/custom_button.dart';
import 'package:chatter_planet_application/widget/reusable/reusable_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //sign in with email and password

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await AuthServices().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      GoRouter.of(context).go('/register');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Sign in with Google
      await AuthServices().signInWithGoogle();

      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing in with Google: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error signing in with Google: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage(
                    "assets/images/chatterplanet-high-resolution-logo-removebg-preview.png"),
                height: 70,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ReusableInput(
                      controller: _emailController,
                      labelText: "Email",
                      icon: Icons.email,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Email";
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ReusableInput(
                      controller: _passwordController,
                      labelText: "Password",
                      icon: Icons.lock,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Password";
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomButton(
                      text: "Log In",
                      width: MediaQuery.of(context).size.width,
                      //todo:login method
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await _signInWithEmailAndPassword(context);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Sign in with Google to access the app's features",
                      style: TextStyle(
                        fontSize: 13,
                        color: mainWhiteColor.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      text: "Sign In with Google",
                      width: MediaQuery.of(context).size.width,
                      //todo:google login
                      onPressed: () => _signInWithGoogle(context),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).go("/register");
                      },
                      child: const Text(
                        'Don\'t have an account? Sign Up',
                        style: TextStyle(color: mainWhiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
