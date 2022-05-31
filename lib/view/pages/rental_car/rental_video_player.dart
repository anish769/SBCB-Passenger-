import 'package:flutter/material.dart';
import 'package:pokhara_app/view/widgets/video_items.dart';
import 'package:video_player/video_player.dart';

class RentalVideoPlayerPage extends StatelessWidget {
  final String vehicleVideoClip;
  RentalVideoPlayerPage({@required this.vehicleVideoClip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: VideoItems(
          videoPlayerController:
              VideoPlayerController.network(vehicleVideoClip),
          looping: false,
          autoplay: true,
        ),
      ),
    );
  }
}
