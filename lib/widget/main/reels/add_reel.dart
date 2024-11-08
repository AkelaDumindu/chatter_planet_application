import 'dart:io';

import 'package:chatter_planet_application/widget/reusable/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddReelModel extends StatefulWidget {
  const AddReelModel({super.key});

  @override
  State<AddReelModel> createState() => _AddReelModelState();
}

class _AddReelModelState extends State<AddReelModel> {
  final _captionController = TextEditingController();
  File? _videoFile;
  bool _isUploading = false;

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(8),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  labelText: 'Caption',
                ),
              ),
              const SizedBox(height: 16),
              _videoFile != null
                  ? Text('Video selected: ${_videoFile!.path}')
                  : const Text('No video selected'),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _pickVideo,
                text: 'Select Video',
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: kIsWeb
                    ? 'Web not supportedd'
                    : _isUploading
                        ? 'Uploading...'
                        : 'Upload Reel',
                width: MediaQuery.of(context).size.width,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
