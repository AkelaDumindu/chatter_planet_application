import 'package:chatter_planet_application/models/reels_model.dart';
import 'package:chatter_planet_application/services/reels/reel_service.dart';
import 'package:chatter_planet_application/widget/main/reels/add_reel.dart';
import 'package:chatter_planet_application/widget/main/reels/reel_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: ReelService().getReels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reels available'));
          }

          final reels = snapshot.data!.docs
              .map((doc) => Reel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: reels.length,
            itemBuilder: (context, index) {
              final reel = reels[index];
              return ReelWidget(
                reel: reel,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReelModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
