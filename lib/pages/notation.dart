import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:franz/components/audio_player.dart';
import 'package:franz/services/api_service.dart';

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
  String _localFilePath ="";

  @override
  void initState() {
    super.initState();
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
              const Text("Sheet Music Viewer"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.link),
                  AudioPlayerButton(),
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
