import 'dart:io';

import 'package:chatter_planet_application/utilz/colors.dart';
import 'package:chatter_planet_application/widget/reusable/custom_button.dart';
import 'package:chatter_planet_application/widget/reusable/reusable_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  File? _imageFile;

//pick image from gallrey using image picker

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
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
                      Stack(
                        children: [
                          _imageFile != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: FileImage(_imageFile!),
                                  backgroundColor: mainPurpleColor,
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://i.stack.imgur.com/l60Hf.png'),
                                  backgroundColor: mainPurpleColor,
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () async {
                                _pickImage(ImageSource.gallery);
                              },
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _nameController,
                        lableText: "Name",
                        icon: Icons.person,
                        obscureText: false,
                        valiator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _emailController,
                        lableText: "Email",
                        icon: Icons.email,
                        obscureText: false,
                        valiator: (value) {
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
                        controller: _jobTitleController,
                        lableText: "Job Title",
                        icon: Icons.work,
                        obscureText: false,
                        valiator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Job Title";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _passwordController,
                        lableText: "Password",
                        icon: Icons.lock,
                        obscureText: false,
                        valiator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Password";
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _confirmPasswordController,
                        lableText: "Confirm Password",
                        icon: Icons.lock,
                        obscureText: false,
                        valiator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Confirm Password";
                          }
                          if (value != _passwordController) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: "Sign Up",
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).go("/login");
                        },
                        child: const Text(
                          'Already have an account? Log in',
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
      ),
    );
  }
}
