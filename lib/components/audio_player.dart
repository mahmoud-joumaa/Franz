import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:franz/global.dart';
import 'package:franz/services/api_service.dart';

class AudioPlayerButton extends StatefulWidget {
  final String audioUrl;
  final AudioPlayer audioPlayer;

  const AudioPlayerButton({
    super.key,
    required this.audioUrl,
    required this.audioPlayer,
  });

  @override
  State<AudioPlayerButton> createState() => _AudioPlayerButtonState();
}

class _AudioPlayerButtonState extends State<AudioPlayerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPlaying = false;
  bool _firstClick = true;
  late AudioPlayer _audioPlayer;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.audioPlayer;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  Future<void> playAudioFromUrl(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: _key,
      onPressed: () {
        setState(() {
          if (_firstClick) {
            print(">> first click");
            print(">> ${_audioPlayer.state}");
            playAudioFromUrl(widget.audioUrl);
            print(">> ${_audioPlayer.state}");
            _animationController.forward();
            _firstClick = false;
          } else {
            if (_isPlaying) {
              print(">> pausing");
              _animationController.reverse();
              print(">> ${_audioPlayer.state}");
              _audioPlayer.pause();
              print(">> ${_audioPlayer.state}");
            } else {
              print(">> resuming");
              _animationController.forward();
              print(">> ${_audioPlayer.state}");
              _audioPlayer.resume();
              print(">> ${_audioPlayer.state}");
            }
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

// =============================================================================

class NewAudioPlayerButton extends StatefulWidget {
  final Function changePlayerState;
  final String audioLink;
  final UniqueKey? playingKey;

  const NewAudioPlayerButton({
    super.key,
    required this.changePlayerState,
    required this.audioLink,
    required this.playingKey,
  });

  @override
  State<NewAudioPlayerButton> createState() => _NewAudioPlayerButtonState();
}

class _NewAudioPlayerButtonState extends State<NewAudioPlayerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late bool _isPlaying;
  final UniqueKey _key = UniqueKey();
  String path = '';
  bool _fetchingFile = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _isPlaying = widget.playingKey == _key;
  }

  @override
  Widget build(BuildContext context) {
    print(
        ">>this is button $_key \ncurrent playing is ${widget.playingKey}\n ${widget.playingKey == _key}\ncurrent animation status: ${_animationController.status.toString()}");
    _isPlaying = widget.playingKey == _key;
    // needs to be paused but is play -> take to pause
    if (_isPlaying && _animationController.status != AnimationStatus.forward) {
      _animationController.forward();
    } else if (!_isPlaying &&
        _animationController.status != AnimationStatus.reverse) {
      _animationController.reverse();
    }
    return TextButton(
      key: _key,
      onPressed: () async {
        if (_isPlaying) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        _isPlaying = !_isPlaying;
        if(_isPlaying){
          setState(() {
            _fetchingFile = true;
          });
          path = await ApiService().loadAudio(widget.audioLink);
          setState(() {
            _fetchingFile = false;
            widget.changePlayerState(_key, path);
          });
        }
        widget.changePlayerState(_key, path);
      },
      child: _fetchingFile ? const Loading(size: 25,) :
      AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: _animationController,
      ),
    );
  }
}
