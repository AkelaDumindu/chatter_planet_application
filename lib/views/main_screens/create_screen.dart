import 'dart:io';

import 'package:chatter_planet_application/utilz/functions/mood.dart';
import 'package:chatter_planet_application/widget/reusable/custom_button.dart';
import 'package:chatter_planet_application/widget/reusable/reusable_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  File? _imageFile;
  Mood _selectedMood = Mood.happy;
  bool _isUploading = false;

  // pick image from gallery or camera

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ReusableInput(
                  controller: _captionController,
                  labelText: 'Caption',
                  icon: Icons.text_fields,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a caption';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButton<Mood>(
                  value: _selectedMood,
                  items: Mood.values.map((Mood mood) {
                    return DropdownMenuItem<Mood>(
                      value: mood,
                      child: Text('${mood.name} ${mood.emoji}'),
                    );
                  }).toList(),
                  onChanged: (Mood? newMood) {
                    setState(() {
                      _selectedMood = newMood ?? _selectedMood;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: kIsWeb //when run web give image as link
                            ? Image.network(_imageFile!.path)
                            : Image.file(
                                _imageFile!,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.5,
                                fit: BoxFit.cover,
                              ))
                    : const Text('No image selected'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Use Camera',
                      onPressed: () => _pickImage(ImageSource.camera),
                      width: MediaQuery.of(context).size.width * 0.43,
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      text: 'Use Gallery',
                      onPressed: () => _pickImage(ImageSource.gallery),
                      width: MediaQuery.of(context).size.width * 0.43,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  // text: kIsWeb ? "Not Supported Yet":"Create Post", //when dont allow create post for web
                  text: "Create Post",
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
