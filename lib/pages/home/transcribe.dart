import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:franz/pages/home/notation.dart';
import 'package:franz/components/audio_player.dart';
import 'package:franz/services/api_service.dart';


class TranscribeScreen extends StatefulWidget {
  const TranscribeScreen({
    super.key,
  });

  @override
  State<TranscribeScreen> createState() => _TranscribeScreenState();
}

class _TranscribeScreenState extends State<TranscribeScreen> with WidgetsBindingObserver{
  final AudioPlayer _audioPlayer = AudioPlayer();
  UniqueKey? _currentPlaying;
  String _searchValue = "";
  String username = 'jelzein';
  
  
  List<Map<String, dynamic>> info = [];


  String parseToUrlString(String input) {
    String encoded = Uri.encodeComponent(input);

    return encoded;
  }

  void changePlayer(UniqueKey key, String audioUrl) {
    print(">> current id playing: $_currentPlaying");
    print(">> requesting id: $key");
    print(">> requesting url: $audioUrl");
    print(">> current player state: ${_audioPlayer.state.toString()}");
    print("\n");

    if (key == _currentPlaying) {
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.pause();
      } else if (_audioPlayer.state == PlayerState.paused) {
        _audioPlayer.resume();
      }
    } else {
      _handleNewAudioSource(key, audioUrl);
    }
  }

  Future<void> _handleNewAudioSource(UniqueKey key, String audioUrl) async {
    await _audioPlayer.stop();
    await _audioPlayer.setSourceUrl(audioUrl);
    await _audioPlayer.setVolume(1);
    await _audioPlayer.resume();

    setState(() {
      _currentPlaying = key;
    });
  }

  void stopAudio() async{
    await _audioPlayer.stop();
    setState(() {
      _currentPlaying = null;
    });
  }

  @override
  void dispose() async{
    stopAudio();
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      stopAudio();
    }
  }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    String title = 'beat it::123123123';
    String audioURL = "https://audio-transcribed-1.s3.eu-west-1.amazonaws.com/${parseToUrlString(username)}/${parseToUrlString(title)}/result.mid";
    info = [{
      "title": "weak and powerless",
      "date": "today",
      "transcriptionLink": "https://arxiv.org/pdf/2111.03017v4.pdf",
      "audioLink": audioURL,
    },
    {
    "title": "nookie",
    "date": "yesterday",
    "transcriptionLink": "https://arxiv.org/pdf/2111.03017v4.pdf",
    "audioLink": "https://filesamples.com/samples/audio/mp3/sample2.mp3"
    }];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                suffixIcon:
                    Icon(Icons.search, color: Theme.of(context).primaryColor),
                border: const OutlineInputBorder(),
                label: const Text("Search your transcriptions"),
              ),
              onChanged: (value) {
                setState(() {
                  _searchValue = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 6,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: info.length,
              itemBuilder: (context, index) {
                return Visibility(
                  visible:
                      info[index]["title"].toString().contains(_searchValue),
                  maintainSize: false,
                  child: TransriptionRow(
                    title: info[index]["title"],
                    date: info[index]["date"],
                    transcriptionLink: info[index]["transcriptionLink"],
                    audioLink: info[index]["audioLink"],
                    audioPlayer: _audioPlayer,
                    changePlayerState: changePlayer,
                    currentPlayingKey: _currentPlaying,
                    onButtonPressed: stopAudio,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransriptionRow extends StatelessWidget {
  final String title;
  final String date;
  final String transcriptionLink;
  final String audioLink;
  final AudioPlayer audioPlayer;
  final Function changePlayerState;
  final UniqueKey? currentPlayingKey;
  final VoidCallback onButtonPressed;

  const TransriptionRow({
    super.key,
    required this.title,
    required this.date,
    required this.transcriptionLink,
    required this.audioLink,
    required this.audioPlayer,
    required this.changePlayerState,
    required this.currentPlayingKey,
    required this.onButtonPressed,
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Text(title),
        ),
        Expanded(
          flex: 3,
          child: Text(date),
        ),
        Expanded(
          flex: 1,
          child: TextButton(
            child: const Icon(Icons.file_copy),
            onPressed: () {
              onButtonPressed();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SheetMusicViewerScreen(
                    link: transcriptionLink,
                    title: title,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: NewAudioPlayerButton(
            changePlayerState: changePlayerState,
            audioLink: audioLink,
            playingKey: currentPlayingKey,
          ),
        ),
      ],
    );
  }
}
