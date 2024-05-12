import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConvertScreen extends StatefulWidget {
  final String title;
  final List<String> items;

  const ConvertScreen({
    Key? key,
    required this.title,
    required this.items,

  }) : super(key: key);

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  List<String> selectedCheckboxes = []; 
  String? selectedRadio;
  String username = "jelzein";

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
                    separatorBuilder: (context, index) => Visibility(visible: selectedRadio != widget.items[index],  child: const Divider()),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return Visibility(
                        visible: selectedRadio != widget.items[index],
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

                    separatorBuilder: (context, index) => Visibility(visible: !selectedCheckboxes.contains(widget.items[index]), child: const Divider()),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return Visibility(
                        visible: !selectedCheckboxes.contains(widget.items[index]),
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

  void Convert() async{
    await callConvertLambda();
  }

  Future<dynamic> callConvertLambda() async {
    String title = parseToUrlString("beat it::123123123");
    Map<String, dynamic> requestBody = {
      'username': username,
      'song_title': title,
      'from_inst': selectedCheckboxes,
      'to_inst': selectedRadio,
    };
    String requestBodyJson = jsonEncode(requestBody);
    print(requestBodyJson);

    final url = Uri.parse('https://tyrog4xb4ilstrkkfvuu4scyte0hxami.lambda-url.eu-west-1.on.aws');

    print("HERE");
    final response = await http.post(
      url,
      body: requestBodyJson,
      headers: {'Content-Type': 'application/json'}, // Specify JSON content type
    );

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
}
