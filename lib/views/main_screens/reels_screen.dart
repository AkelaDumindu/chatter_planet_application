import 'package:chatter_planet_application/widget/main/reels/add_reel.dart';
import 'package:flutter/material.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _showAddReelModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => AddReelModel(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reels'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReelModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
