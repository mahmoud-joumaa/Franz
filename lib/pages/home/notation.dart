import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:franz/components/audio_player.dart';
import 'package:franz/services/api_service.dart';
import 'package:franz/pages/home/convert.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';



class SheetMusicViewerScreen extends StatefulWidget {
  final String link;
  final String title;

  const SheetMusicViewerScreen({
    super.key,
    required this.link,
    required this.title,
  });

  @override
  State<SheetMusicViewerScreen> createState() => _SheetMusicViewerScreenState();
}

class _SheetMusicViewerScreenState extends State<SheetMusicViewerScreen> {
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String _localFilePath = "";
  AudioPlayer _audioPlayer = AudioPlayer();
  List<String> instruments = [];
  String selectedInstrument = '';
  String username = "jelzein";
  String title = 'beat it::123123123';

  @override
  void initState() {
    super.initState();
  }

  String parseToUrlString(String input) {
    // Replace spaces with plus signs
    String urlEncoded = input.replaceAll(' ', '+');

    // Encode special characters
    String urlEncodedSpecial = Uri.encodeFull(urlEncoded);

    return urlEncodedSpecial;
  }


  Future<void> getPdfUrl() async {
    await listFoldersInFolder("audio-transcribed-1", "jelzein/beat+it%3A%3A123123123/");
    print(selectedInstrument);
    String parsedInstrument = parseToUrlString(selectedInstrument!);
    _localFilePath = await ApiService().loadPDF(
        "https://audio-transcribed-1.s3.eu-west-1.amazonaws.com/${parseToUrlString(username)}/${parseToUrlString(title)}/$parsedInstrument/result.pdf");
  }

  Future<void> listFoldersInFolder(String bucketName,
      String folderPrefix) async {
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

      instruments = folderNames.map((f) =>
          f.split('/').elementAt(f
              .split('/')
              .length - 2)).toList();

      if (selectedInstrument == '') {
        selectedInstrument = instruments.first;
      }

      print('Folders in $folderPrefix:');
      print(folderNames);
    } else {
      print('Failed to list folders. Status code: ${response.statusCode}');
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
      ),
      body: FutureBuilder<void>(
        future: getPdfUrl(), // Replace with your method to get PDF URL
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
                          onPressed: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ConvertScreen(title: widget.title, items: instruments,),
                                ),
                              ),
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
                          audioUrl: "https://filesamples.com/samples/audio/mp3/sample2.mp3",
                        ),
                      ],
                    ),
                    Text(errorMessage),
                    Expanded(
                      child: _localFilePath == ""
                          ? const Center(child: CircularProgressIndicator())
                          : PDFView(
                        filePath: _localFilePath,
                      ),
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