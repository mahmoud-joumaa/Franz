import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:franz/components/audio_recorder.dart';
import 'package:franz/pages/home/home.dart';

class NewTransScreen extends StatefulWidget {
  const NewTransScreen({super.key});

  @override
  State<NewTransScreen> createState() => _NewTransScreenP1State();
}

class _NewTransScreenP1State extends State<NewTransScreen> {
  String _mode = "Audio";
  String _instrument = "Piano";
  String _selectedFileName = "";
  TextEditingController _ytlink = TextEditingController();
  bool hasError = false;
  String? audioPath = "";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _pickFile() async {
    // Open the file picker and allow multiple file selection
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    // Check if any file was picked
    if (result != null) {
      // You can access the picked files using result.files
      // For example, to print the name of the first picked file
      print(result.files.first.name);
      setState(() {
        _selectedFileName = result.files.first.name;
      });
    }
  }

  Future<void> deleteAudioFile(String filePath) async {
    try {
      // Create a File object representing the audio file
      File audioFile = File(filePath);

      // Check if the file exists
      if (await audioFile.exists()) {
        // Delete the file
        await audioFile.delete();
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  void _cancelRecord() {
    setState(() {
      deleteAudioFile(audioPath!);
      audioPath = "";
    });
  }

  void Transcribe() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: const Text("Add a Transcription"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: (MediaQuery.of(context).size.height - 75),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Title"),
                  ),
                                ),
                ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Author"),
                    ),
                  ),
              ),
                const Divider(),
                RadioListTile(
                  title: const Text('Audio File'),
                  subtitle:
                      const Text("Select an audio file from your local storage"),
                  value: "Audio",
                  groupValue: _mode,
                  onChanged: (String? value) {
                    setState(() {
                      _mode = value!;
                      _cancelRecord();
                      _ytlink.text = '';
                    });
                  },
                ),
                const SizedBox(height: 5),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: _mode == "Audio",
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _pickFile,
                        child: const Text("Choose file"),
                      ),
                      Visibility(
                        maintainSize: false,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: _selectedFileName != "",
                        child: Text(_selectedFileName),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),
                RadioListTile(
                  title: const Text('Youtube Link'),
                  subtitle: const Text("Enter the link to a youtube video"),
                  value: "Link",
                  groupValue: _mode,
                  onChanged: (String? value) {
                    setState(() {
                      _mode = value!;
                      _cancelRecord();
                      _selectedFileName = "";
                    });
                  },
                ),
                const SizedBox(height: 5),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: _mode == "Link",
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _ytlink,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Youtube Link"),
                      ),

                    ),
                  ),
                ),
                RadioListTile(
                  title: const Text('Record Audio'),
                  subtitle: const Text("Record your own audio"),
                  value: "Record",
                  groupValue: _mode,
                  onChanged: (String? value) {
                    setState(() {
                      _mode = value!;
                      _selectedFileName = "";
                      _ytlink.text = '';
                    });
                  },
                ),
                const SizedBox(height: 5),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: _mode == "Record",
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Visibility(
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: audioPath == '',
                          child: Recorder(
                            onStop: (path) {
                              setState(() {
                                audioPath = path;
                              });
                            },
                          ),
                        ),
                        Visibility(
                          maintainSize: false,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: audioPath != '',
                          child: Row(
                            children: [
                              Text(audioPath!.split('/').last),
                              TextButton(
                                  onPressed: _cancelRecord, child: const Text("Cancel"))
                            ],
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                if (hasError) const Text("Error: You need to select an audio source and input a title", style: TextStyle(color: Colors.red),) else Text(''),
                const Spacer(),
                Row(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Back")),
                    const Spacer(),
                    TextButton(
                          onPressed: () {
                            if (((audioPath != '') || (_ytlink.text != '') || (_selectedFileName != '')) && (titleController.text != '')) {
                              Transcribe();
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                hasError = true;
                              });
                            }
                        },
                        child: const Text("Transcribe"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}