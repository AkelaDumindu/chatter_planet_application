import 'package:chatter_planet_application/models/reels_model.dart';
import 'package:chatter_planet_application/services/reels/reel_service.dart';
import 'package:chatter_planet_application/widget/main/reels/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReelWidget extends StatelessWidget {
  final Reel reel;
  const ReelWidget({super.key, required this.reel});

  //delete reel
  void _deleteReel() async {
    await ReelService().deleteReel(reel);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reel.caption,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayerWidget(
                videoUrl: reel.videoUrl,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {
                    // Handle like functionality
                    //todo
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit functionality
                    //todo
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteReel,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
