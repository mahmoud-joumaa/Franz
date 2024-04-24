import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:franz/services/api_service.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
    // TODO: implement initState
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
      body: Center(
        child: Column(
          children: [
            const Text("Sheet Music Viewer"),
            Text(widget.link),
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
}
