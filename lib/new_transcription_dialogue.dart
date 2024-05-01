import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class NewTransDialogue extends StatefulWidget {
  const NewTransDialogue({super.key});

  @override
  State<NewTransDialogue> createState() => _NewTransDialogueState();
}

class _NewTransDialogueState extends State<NewTransDialogue> {
  String _mode = "Audio";
  String _instrument = "Piano";
  String _selectedFileName = "";
  int _page = 0;

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

  void _movePage() {
    setState(() {
      _page++;
    });
  }

  void _movePageBack() {
    setState(() {
      _page--;
    });
  }

  void _triggerLambda() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("Let's Transcribe!"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  maintainState: true,
                  maintainSize: false,
                  visible: _page == 0,
                  child: Column(
                    children: [
                      RadioListTile(
                        title: const Text('Audio File'),
                        subtitle: const Text(
                          // "Select an audio file from your local storage",
                          "Select audio from local storage"
                        ),
                        value: "Audio",
                        groupValue: _mode,
                        onChanged: (String? value) {
                          setState(() {
                            _mode = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 5),
                      Visibility(
                        maintainSize: false,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: _mode == "Audio",
                        child: TextButton(
                          onPressed: _pickFile,
                          child: const Text("Choose file"),
                        ),
                      ),
                      Visibility(
                        maintainSize: false,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: _selectedFileName != "",
                        child: Text(_selectedFileName),
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
                          });
                        },
                      ),
                      const SizedBox(height: 5),
                      Visibility(
                        maintainSize: false,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: _mode == "Link",
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Youtube Link"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text("Choose your instrument:"),
                      const SizedBox(height: 5),
                      DropdownButton<String>(
                        value: _instrument,
                        isExpanded: false,
                        items: const [
                          DropdownMenuItem(
                            value: "Piano",
                            child: Text("Piano"),
                          ),
                          DropdownMenuItem(
                            value: "Guitar",
                            child: Text("Guitar"),
                          ),
                          DropdownMenuItem(
                            value: "Drums",
                            child: Text("Drums"),
                          ),
                          DropdownMenuItem(
                            value: "Bass",
                            child: Text("Bass"),
                          ),
                        ],
                        onChanged: (cat) {
                          setState(() {
                            _instrument = cat!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  maintainState: true,
                  maintainSize: false,
                  visible: _page == 1,
                  child: const Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Song Title *"),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Song Artist"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            Visibility(
              visible: _page == 0,
              child: TextButton(
                onPressed: _movePage,
                child: const Text("Next"),
              ),
            ),
            Visibility(
              visible: _page == 1,
              child: TextButton(
                onPressed: _movePageBack,
                child: const Text("Back"),
              ),
            ),
            Visibility(
              visible: _page == 1,
              child: TextButton(
                onPressed: _triggerLambda,
                child: const Text("Submit"),
              ),
            ),
          ],
        );
      },
    );
  }
}
