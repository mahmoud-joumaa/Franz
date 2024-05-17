// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:franz/components/audio_recorder.dart';
import 'package:franz/pages/home/home.dart';
import 'package:http/http.dart' as http;

class NewTransScreen extends StatefulWidget {
  const NewTransScreen({super.key});

  @override
  State<NewTransScreen> createState() => _NewTransScreenState();
}

class _NewTransScreenState extends State<NewTransScreen> {
  String _mode = "Audio";
  String _selectedFileName = "";
  final TextEditingController _ytlink = TextEditingController();
  bool hasError = false;
  String? audioPath = "";
  final TextEditingController titleController = TextEditingController();
  bool _isTranscribing = false;
  String? username = MyHomePage.user?.authDetails.username;

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
        _selectedFileName = result.files.first.path!;
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
    }
    catch (e) {
      print(e);
    }
  }

  void _cancelRecord() {
    setState(() {
      deleteAudioFile(audioPath!);
      audioPath = "";
    });
  }



  void transcribe() async{
    dynamic result;
    setState(() {
      _isTranscribing = true;
    });
    if (_ytlink.text == '' && _selectedFileName == '' && audioPath != ''){
      List<int> file = await getFileBytes(audioPath!);
      DateTime now = DateTime.now();
      String url = 'https://audio-unprocessed-1.s3.amazonaws.com/';
      result = await uploadToS3(
          uploadUrl: url,
          data: {"key": '${parseToUrlString(username!)}/${parseToUrlString(titleController.text)}::${now.millisecondsSinceEpoch ~/ 1000}/${parseToUrlString(audioPath!.split('/').last)}'},
          fileAsBinary: file,
          filename: audioPath!.split('/').last
      );
    } else if (_ytlink.text == '' && _selectedFileName != '' && audioPath == ''){
      List<int> file = await getFileBytes(_selectedFileName);
      DateTime now = DateTime.now();
      String url = 'https://audio-unprocessed-1.s3.eu-west-1.amazonaws.com/';
      String key = '${parseToUrlString(username!)}/${parseToUrlString(titleController.text)}::${now.millisecondsSinceEpoch ~/ 1000}/${parseToUrlString(_selectedFileName.split('/').last)}';
      result = await uploadToS3(
          uploadUrl: url,
          data: {"key": key},
          fileAsBinary: file,
          filename: _selectedFileName.split('/').last
      );
    } else if(_ytlink.text != '' && _selectedFileName == '' && audioPath == ''){
      result = await callYTDownload();
      if(result != null && result.body != null && result.body != 'null' && result.statusCode == 200){
        // Display success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Success'),
              content: const Text('File uploaded successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();// Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        ).then((_) {
          // Popping twice when the dialog is dismissed
          Navigator.of(context).pop();
        });
      }
      else{
        // Display success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Somthing Went Wrong'),
              content: const Text('Unable to upload file'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();// Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        ).then((_) {
          // Popping twice when the dialog is dismissed
          Navigator.of(context).pop();
        });
      }
      return;
    }


    if(result != null && result.runtimeType == bool && result){
        // Display success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload Success'),
              content: const Text('File uploaded successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        ).then((_) {
          // Popping twice when the dialog is dismissed
          Navigator.of(context).pop();
        });
    }
    else{
      // Display success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Somthing Went Wrong'),
            content: const Text('Unable to upload file'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ).then((value) => Navigator.pop(context));
    }



  }

  Future<dynamic> callYTDownload() async {
    final encodedYoutubeUrl = Uri.encodeQueryComponent(_ytlink.text);
    // print(encodedYoutubeUrl);
    final url = Uri.parse('https://cunmicltthdzba3akzwazo34q40xikyz.lambda-url.eu-west-1.on.aws?url=$encodedYoutubeUrl&username=${parseToUrlString(username!)}&song_title=${parseToUrlString(titleController.text)}');

    // print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Request successful, handle response
      print('Lambda function invoked successfully');
      print('Response: ${response.body}');
    } else {
      // Request failed, handle error
      print('Failed to invoke Lambda function');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    return response;
  }


  String parseToUrlString(String input) {
    String encoded = Uri.encodeComponent(input);

    return encoded;
  }

  Future<List<int>> getFileBytesAndName(String path) async {
    List<int> bytes;
    bytes = await getFileBytes(path);
    return bytes;
  }

  Future<List<int>> getFileBytes(String path) async {
    File file = File(path);
    List<int> fileBytes = await file.readAsBytes();

    return fileBytes;
  }

  Future<bool> uploadToS3({
    required String uploadUrl,
    required Map<String, String> data,
    required List<int> fileAsBinary,
    required String filename,
  }) async {
    var multiPartFile = http.MultipartFile.fromBytes('file', fileAsBinary, filename: filename);
    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(data)
      ..files.add(multiPartFile);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 204) {
      print('Uploaded!');
      return true;
    }
    return false;
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
                if (hasError) const Text("Error: You need to select an audio source and input a title", style: TextStyle(color: Colors.red),) else const Text(''),
                const Spacer(),
                Row(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Back")),
                    const Spacer(),
                    _isTranscribing? const CircularProgressIndicator() : TextButton(
                          onPressed: () {
                            if (((audioPath != '') || (_ytlink.text != '') || (_selectedFileName != '')) && (titleController.text != '')) {
                              transcribe();
                            } else {
                              setState(() {
                                hasError = true;
                              });
                            }
                        },
                        child:  const Text("Transcribe"))
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
