import 'package:flutter/material.dart';
import 'package:franz/pages/notation.dart';

class TranscribeScreen extends StatefulWidget {
  const TranscribeScreen({super.key});

  @override
  State<TranscribeScreen> createState() => _TranscribeScreenState();
}

class _TranscribeScreenState extends State<TranscribeScreen> {
  List<Map<String, dynamic>> info = [
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://arxiv.org/pdf/2111.03017v4.pdf"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "assets/1205.2618.pdf"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
    {
      "title": "weak and powerless",
      "date": "today",
      "link": "https://www.jalal.com"
    },
  ];

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
            ),
          ),
          Expanded(
            flex: 6,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: info.length,
              itemBuilder: (context, index) {
                return TransriptionRow(
                  title: info[index]["title"],
                  date: info[index]["date"],
                  link: info[index]["link"],
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
  final String link;

  const TransriptionRow({
    super.key,
    required this.title,
    required this.date,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(date),
        TextButton(
          child: const Icon(Icons.file_copy),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SheetMusicViewerScreen(
                  link: link,
                  title: title,
                ),
              ),
            );
          },
        ),
        TextButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () {},
        ),
      ],
    );
  }
}
