import 'dart:io';
import 'package:chatter_planet_application/models/user_model.dart';
import 'package:chatter_planet_application/services/reels/reel_service.dart';
import 'package:chatter_planet_application/services/reels/reel_storage.dart';
import 'package:chatter_planet_application/services/users/user_service.dart';
import 'package:chatter_planet_application/widget/reusable/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void _submitReel() async {
    if (_videoFile != null && _captionController.text.isNotEmpty) {
      try {
        //loading
        setState(() {
          _isUploading = true;
        });

        if (kIsWeb) {
          return;
        }

        // Upload video to Firebase Storage
        final videoUrl = await ReelStorageService().uploadVideo(
          videoFile: _videoFile!,
          userId: FirebaseAuth.instance.currentUser!.uid,
        );

        // get user date
        final UserModel? userData = await UserService()
            .getUserById(FirebaseAuth.instance.currentUser!.uid);
        final reelDetails = {
          'caption': _captionController.text,
          'videoUrl': videoUrl,
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'userName': userData?.name,
          'profileImage': userData?.imageUrl
        };

        await ReelService().saveReel(reelDetails);

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reel added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add reel')),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
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
                onPressed: _submitReel,
              )
            ],
          ),
        ),
      ),
    );
  }
}
