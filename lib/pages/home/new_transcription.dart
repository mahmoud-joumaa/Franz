import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:franz/components/audio_recorder.dart';
import 'package:franz/pages/home/home.dart';

class NewTransScreenP1 extends StatefulWidget {
  const NewTransScreenP1({super.key});

  @override
  State<NewTransScreenP1> createState() => _NewTransScreenP1State();
}

class _NewTransScreenP1State extends State<NewTransScreenP1> {
  String _mode = "Audio";
  String _instrument = "Piano";
  String _selectedFileName = "";
  TextEditingController _ytlink = TextEditingController();
  bool hasError = false;
  String? audioPath = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: const Text("Choose Source Type"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: (MediaQuery.of(context).size.height - 75),

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    padding: EdgeInsets.all(16.0),
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
                                  onPressed: _cancelRecord, child: Text("Cancel"))
                            ],
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                if (hasError) const Text("Error: You need to select an audio", style: TextStyle(color: Colors.red),) else Text(''),
                Spacer(),
                Row(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Back")),
                    Spacer(),
                    TextButton(
                          onPressed: () {
                            if ((audioPath != '') || (_ytlink.text != '') || (_selectedFileName != '')) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NewTransScreenP2(),
                                ),
                              );
                            } else {
                              setState(() {
                                hasError = true;
                              });
                            }
                        },
                        child: Text("Next"))
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

class NewTransScreenP2 extends StatefulWidget {
  const NewTransScreenP2({super.key});

  @override
  State<NewTransScreenP2> createState() => _NewTransScreenP2State();
}

class _NewTransScreenP2State extends State<NewTransScreenP2> {
  List<bool> checked = List.generate(128, (index) => true);
  List<String> midiPrograms = [
    'Acoustic Grand Piano',
    'Bright Acoustic Piano',
    'Electric Grand Piano',
    'Honky-tonk Piano',
    'Electric Piano 1',
    'Electric Piano 2',
    'Harpsichord',
    'Clavinet',
    'Celesta',
    'Glockenspiel',
    'Music Box',
    'Vibraphone',
    'Marimba',
    'Xylophone',
    'Tubular Bells',
    'Dulcimer',
    'Drawbar Organ',
    'Percussive Organ',
    'Rock Organ',
    'Church Organ',
    'Reed Organ',
    'Accordion',
    'Harmonica',
    'Tango Accordion',
    'Acoustic Guitar (nylon)',
    'Acoustic Guitar (steel)',
    'Electric Guitar (jazz)',
    'Electric Guitar (clean)',
    'Electric Guitar (muted)',
    'Overdriven Guitar',
    'Distortion Guitar',
    'Guitar Harmonics',
    'Acoustic Bass',
    'Electric Bass (finger)',
    'Electric Bass (pick)',
    'Fretless Bass',
    'Slap Bass 1',
    'Slap Bass 2',
    'Synth Bass 1',
    'Synth Bass 2',
    'Violin',
    'Viola',
    'Cello',
    'Contrabass',
    'Tremolo Strings',
    'Pizzicato Strings',
    'Orchestral Harp',
    'Timpani',
    'String Ensemble 1',
    'String Ensemble 2',
    'SynthStrings 1',
    'SynthStrings 2',
    'Choir Aahs',
    'Voice Oohs',
    'Synth Voice',
    'Orchestra Hit',
    'Trumpet',
    'Trombone',
    'Tuba',
    'Muted Trumpet',
    'French Horn',
    'Brass Section',
    'SynthBrass 1',
    'SynthBrass 2',
    'Soprano Sax',
    'Alto Sax',
    'Tenor Sax',
    'Baritone Sax',
    'Oboe',
    'English Horn',
    'Bassoon',
    'Clarinet',
    'Piccolo',
    'Flute',
    'Recorder',
    'Pan Flute',
    'Blown Bottle',
    'Shakuhachi',
    'Whistle',
    'Ocarina',
    'Lead 1 (square)',
    'Lead 2 (sawtooth)',
    'Lead 3 (calliope)',
    'Lead 4 (chiff)',
    'Lead 5 (charang)',
    'Lead 6 (voice)',
    'Lead 7 (fifths)',
    'Lead 8 (bass + lead)',
    'Pad 1 (new age)',
    'Pad 2 (warm)',
    'Pad 3 (polysynth)',
    'Pad 4 (choir)',
    'Pad 5 (bowed)',
    'Pad 6 (metallic)',
    'Pad 7 (halo)',
    'Pad 8 (sweep)',
    'FX 1 (rain)',
    'FX 2 (soundtrack)',
    'FX 3 (crystal)',
    'FX 4 (atmosphere)',
    'FX 5 (brightness)',
    'FX 6 (goblins)',
    'FX 7 (echoes)',
    'FX 8 (sci-fi)',
    'Sitar',
    'Banjo',
    'Shamisen',
    'Koto',
    'Kalimba',
    'Bag pipe',
    'Fiddle',
    'Shanai',
    'Tinkle Bell',
    'Agogo',
    'Steel Drums',
    'Woodblock',
    'Taiko Drum',
    'Melodic Tom',
    'Synth Drum',
    'Reverse Cymbal',
    'Guitar Fret Noise',
    'Breath Noise',
    'Seashore',
    'Bird Tweet',
    'Telephone Ring',
    'Helicopter',
    'Applause',
    'Gunshot'
  ];
  bool allSelected = true;
  String _searchValue = "";

  @override
  void initState() {
    super.initState();
  }

  void selectAll(value) {
    setState(() {
      for (int i = 0; i < checked.length; i++) {
        checked[i] = value;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
          title: const Text("Pick Instruments"),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon:
                      Icon(Icons.search, color: Theme.of(context).primaryColor),
                      border: const OutlineInputBorder(),
                      label: const Text("Search Instrument"),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchValue = value;
                      });
                    },
                  ),

                ),
                Container(
                  margin: const EdgeInsets.only(right: 25),
                  child: Checkbox(
                    value: allSelected,
                    onChanged: (value) {
                      allSelected = value!;
                      selectAll(value);
                    }),
                ),
        ]
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: ListView.separated(
                    separatorBuilder: (context, index) => (midiPrograms[index].toLowerCase().contains(_searchValue.toLowerCase())) ? const Divider() : const SizedBox(),
                    itemCount: checked.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(midiPrograms[index].toLowerCase().contains(_searchValue.toLowerCase())) {
                        return SizedBox(
                          height: 35,
                          child: CheckboxListTile(
                              title: Text(midiPrograms[index]),
                              value: checked[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  checked[index] = value!;
                                });

                              },
                                                ),
                        );
                      }
                      else{
                        return const SizedBox();
                      }
                    }),
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Back")),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(title: "Franz"),
                        ),
                      );
                    },
                    child: const Text("Transcribe"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
