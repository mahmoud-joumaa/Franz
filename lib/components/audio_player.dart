import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerButton extends StatefulWidget {
  const AudioPlayerButton({super.key});

  @override
  State<AudioPlayerButton> createState() => _AudioPlayerButtonState();
}

class _AudioPlayerButtonState extends State<AudioPlayerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          if (_isPlaying) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
          _isPlaying = !_isPlaying;
        });
      },
      child: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: _animationController,
      ),
    );
  }
}
