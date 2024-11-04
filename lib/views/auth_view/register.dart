import 'dart:io';

import 'package:chatter_planet_application/models/user_model.dart';
import 'package:chatter_planet_application/services/users/user_service.dart';
import 'package:chatter_planet_application/services/users/user_storage.dart';
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

  // signup with email and password
  Future<void> _registerUser(BuildContext context) async {
    try {
      // store image in storage and get download url
      if (_imageFile != null) {
        final imageUrl = await UserProfileStorageService().uploadImage(
            profileImage: _imageFile, userEmail: _emailController.text);
        _imageUrlController.text = imageUrl;
      }

      // save user to firestore

      UserService().saveUser(
        UserModel(
            userId: "",
            name: _nameController.text,
            email: _emailController.text,
            jobTitle: _jobTitleController.text,
            imageUrl: _imageUrlController.text,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            password: _passwordController.text,
            followers: 0),
      );

      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully'),
        ),
      );

      GoRouter.of(context).go('/main-screen');
    } catch (e) {
      print('Error signing up with email and password: $e');
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up with email and password: $e'),
        ),
      );
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
                        labelText: "Name",
                        icon: Icons.person,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                        controller: _jobTitleController,
                        labelText: "Job Title",
                        icon: Icons.work,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Job Title";
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
                      const SizedBox(height: 16),
                      ReusableInput(
                        controller: _confirmPasswordController,
                        labelText: "Confirm Password",
                        icon: Icons.lock,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Confirm Password";
                          }

                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: "Sign Up",
                        width: MediaQuery.of(context).size.width,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await _registerUser(context);
                          }
                        },
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
