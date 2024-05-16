import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:franz/components/audio_player.dart';
import 'package:franz/global.dart';
import 'package:franz/pages/home/home.dart';
import 'package:franz/services/api_service.dart';
import 'package:franz/pages/home/convert.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';



class SheetMusicViewerScreen extends StatefulWidget {
  final String link;
  final String title;
  final String id;

  const SheetMusicViewerScreen({
    super.key,
    required this.link,
    required this.title,
    required this.id,
  });

  @override
  State<SheetMusicViewerScreen> createState() => _SheetMusicViewerScreenState();
}

class _SheetMusicViewerScreenState extends State<SheetMusicViewerScreen> with WidgetsBindingObserver{
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String _localFilePath = "";
  String _localAudioPath = "";
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> instruments = [];
  String selectedInstrument = '';
  String? username = MyHomePage.user?.authDetails.username;
  String? preferredInstrument = MyHomePage.user?.preferredInstrument;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  String parseToUrlString(String input) {
    String encoded = Uri.encodeComponent(input);
    return encoded;
  }


  Future<void> getRequriedData(context) async {
    String parsedInstrument = parseToUrlString(selectedInstrument);

    String pdfURL = "https://audio-transcribed-1.s3.eu-west-1.amazonaws.com/${parseToUrlString(username!)}/${parseToUrlString(widget.id)}/${parsedInstrument.replaceAll(' ', '+')}/result.pdf";
    String audioURL = "https://audio-transcribed-1.s3.eu-west-1.amazonaws.com/${parseToUrlString(username!)}/${parseToUrlString(widget.id)}/${parsedInstrument.replaceAll(' ', '+')}/result.mid";
    await listFoldersInFolder(context, "audio-transcribed-1", parseToUrlString("${username!}/${widget.id}/"));
    _localFilePath = await ApiService().loadPDF(pdfURL);
    _localAudioPath = await ApiService().loadAudio(audioURL);
  }

  Future<void> listFoldersInFolder(context, String bucketName, String folderPrefix) async {
    final request = http.Request(
      'GET',
      Uri.parse(
          'https://$bucketName.s3.amazonaws.com/?prefix=$folderPrefix&delimiter=/'),
    );

    // Send the request and wait for the response
    final response = await http.Client().send(request);

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the XML response to extract folder names
      final responseBody = await response.stream.bytesToString();
      final xml = XmlDocument.parse(responseBody);

      final folderNames = xml.findAllElements('CommonPrefixes')
          .map((element) =>
      element
          .findElements('Prefix')
          .first
          .text)
          .toList();
      print(folderNames);
      instruments = folderNames.map((f) =>
          f.split('/').elementAt(f
              .split('/')
              .length - 2)).toList();
      print(instruments);
      print(preferredInstrument);
      selectedInstrument = instruments.first;
      if(preferredInstrument == null || preferredInstrument == 'None'){
        preferredInstrument = instruments.first;
      }
      else{
        for(String instrument in instruments){
          for(var entry in Instruments.midiInstruments.entries){
            if(entry.value.contains(instrument)){
              selectedInstrument = instrument;
              break;
            }
          }
          if (selectedInstrument != '') break;
        }
      }

    }
    else {
      Alert.show(
        context,
        "Failed to list instruments",
        "Error code: ${response.statusCode}",
        UserTheme.isDark ? Colors.redAccent[700]! : Colors.redAccent[100]!,
        "dismiss");
    }

  }

  void stopAudio() async{
    await _audioPlayer.stop();
    setState((){});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      stopAudio();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async{
            stopAudio();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<void>(
        future: getRequriedData(context), // Replace with your method to get PDF URL
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async{
                              stopAudio();
                              setState(() {

                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ConvertScreen(title: widget.title, items: instruments, id: widget.id),
                                ),
                              );
                          },
                          icon: const Icon(Icons.swap_horiz),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                hintText: 'Select item',
                                border: OutlineInputBorder(),
                              ),
                              value: selectedInstrument,
                              // Set the current selected item
                              onChanged: (String? value) {
                                setState(() {
                                  _audioPlayer.stop();
                                  selectedInstrument = value!;
                                });
                              },
                              items: instruments.map<DropdownMenuItem<String>>((
                                  String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        AudioPlayerButton(
                          audioPlayer: _audioPlayer,
                          audioUrl: _localAudioPath,
                        ),
                      ],
                    ),
                    Text(errorMessage),
                    FutureBuilder<void>(
                    future: getRequriedData(context), // Replace with your method to get PDF URL
                    builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                    } else {
                    return Expanded(
                      child: _localFilePath == ""
                          ? const Center(child: CircularProgressIndicator())
                          : PDFView(
                        filePath: _localFilePath,
                      ),
                    );

                    }
                    }
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
