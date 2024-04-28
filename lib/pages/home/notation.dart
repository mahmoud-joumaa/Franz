import 'package:flutter/material.dart';

class SheetMusicViewerScreen extends StatelessWidget {
  final String link;
  final String title;

  const SheetMusicViewerScreen({
    super.key,
    required this.link,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Sheet Music Viewer"),
            Text(link),
          ],
        ),
      ),
    );
  }
}
