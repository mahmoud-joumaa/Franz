import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:franz/components/audio_player.dart';
import 'package:franz/services/api_service.dart';
import 'package:franz/pages/home/convert.dart';

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
  List<String> instruments = ["Instrument 1", "Instrument 2", "Instrument 3", "Instrument 4", "Instrument 5", "Instrument 6", "Instrument 7", "Instrument 8", "Instrument 9", "Instrument 10", "Instrument 11", "Instrument 12", "Instrument 13", "Instrument 14", "Instrument 15", "Instrument 16", "Instrument 17", "Instrument 18"];
  String? selectedInstrument;

  @override
  void initState() {
    super.initState();
    selectedInstrument = instruments.first;
    ApiService().loadPDF(widget.link).then((value) {
      setState(() {
        _localFilePath = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConvertScreen(title: widget.title,),
                        ),
                      ),
                      icon: const Icon(Icons.swap_horiz)
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          hintText: 'Select item',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedInstrument, // Set the current selected item
                        onChanged: (String? value) {
                          setState(() {
                            selectedInstrument = value; // Update the selected item
                          });
                        },
                        items: instruments.map<DropdownMenuItem<String>>((String item) {
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
      ),
    );
  }
}
