import 'package:flutter/material.dart';

class ConvertScreen extends StatefulWidget {
  final String title;

  const ConvertScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  List<String> items = ["Item 1", "Item 2", "Item 3","Item 4", "Item 5", "Item 6","Item 7", "Item 8", "Item 9"]; // Sample list of items
  List<String> selectedCheckboxes = []; 
  String? selectedRadio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Convert",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Visibility(visible: selectedRadio != items[index],  child: const Divider()),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Visibility(
                        visible: selectedRadio != items[index],
                        child: SizedBox(
                          height: 40,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero, // Remove extra padding
                            title: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(item),
                            ),
                            value: selectedCheckboxes.contains(item),
                            onChanged: (value) {
                              setState(() {
                                if (value != null && value) {
                                  selectedCheckboxes.add(item);
                                } else {
                                  selectedCheckboxes.remove(item);
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Divider(height: 10,),
            const SizedBox(height: 10,),
            const Text(
              "To",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Card(
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.separated(

                    separatorBuilder: (context, index) => Visibility(visible: !selectedCheckboxes.contains(items[index]), child: const Divider()),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Visibility(
                        visible: !selectedCheckboxes.contains(items[index]),
                        child: SizedBox(
                          height: 40,
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(item),
                            ),
                            value: item,
                            groupValue: selectedRadio,
                            onChanged: (value) {
                              setState(() {
                                selectedRadio = value;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing, // Align radio buttons to the right
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            ),
            
            Center(child: TextButton(onPressed: Convert, child: const Text("Convert")))
          ],
        ),
      ),
    );
  }

  void Convert() {
  }
}
