import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:franz/global.dart';
import 'package:franz/pages/home/notation.dart';
import 'package:franz/components/audio_player.dart';
import 'package:franz/services/api_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/* ================================================================================================
DynamoDB API Start
================================================================================================ */

const username = "jelzein"; // Username to use for queries

// Connection Initialization ======================================================================

class DynamoAPI {
  static const url = "https://6o5qxygbgbhtla6jocplyoskui.appsync-api.eu-west-1.amazonaws.com/graphql";
  static const key = "da2-wri7ol4zujfwrbwrtexkupbq7q"; // COMBAK: Hide api key
}

// Queries ========================================================================================

const getUserTranscriptions = """query listTranscriptions {
  listTranscriptions(filter: {account_id: {eq: "$username"}}) {
    items {
      account_id
      transcription_id
      title
      transcription_date
      s3_bucket
      metadata
    }
  }
}""";

// Initialize Client ==============================================================================

GraphQLClient client = DynamoGraphQL.initializeClient();

/* ================================================================================================
DynamoDB API End
================================================================================================ */


class TranscribeScreen extends StatefulWidget {
  const TranscribeScreen({
    super.key,
  });

  @override
  State<TranscribeScreen> createState() => _TranscribeScreenState();
}

class _TranscribeScreenState extends State<TranscribeScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();
  UniqueKey? _currentPlaying;
  String _searchValue = "";

  String status = "loading"; // Check status of dynamo fetch

  List<Map<String, dynamic>> info = [];

  void changePlayer(UniqueKey key, String audioUrl) {

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

  renderTranscriptions() async {
    return await client.query(QueryOptions(document: gql(getUserTranscriptions)));
  }

  @override
  void initState() {
    super.initState();
    renderTranscriptions().then((result) {
      if (result.isLoading) {
        setState(() {status = "loading";});
      }
      else {
        var responseItems = result.data?['listTranscriptions']?['items'];
        if (responseItems.isEmpty) {
          setState(() { status = "empty"; });
        }
        else {
          for (final item in responseItems) { // title, date, transcriptionLink, audioLink
            info.add({
              "title": item["title"],
              "date": item["transcription_date"],
              "transcriptionLink": '${item["s3_bucket"]}/result.pdf',
              "audioLink": '${item["s3_bucket"]}/result.mid',
            });
          }
          setState(() { status = "done"; });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return status == "loading" ? const Loading(backgroundColor: Colors.white, color: Colors.deepPurple) : Padding(
      padding: const EdgeInsets.all(16.0),
      child: status == "empty" ? const Center(child: Text("It appears you don't have any transcriptions yet!\nUse the plus button to start transcribing your favorite tunes!", textAlign: TextAlign.center)) : Column(
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

  const TransriptionRow({
    super.key,
    required this.title,
    required this.date,
    required this.transcriptionLink,
    required this.audioLink,
    required this.audioPlayer,
    required this.changePlayerState,
    required this.currentPlayingKey,
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
