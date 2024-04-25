import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = "English";
  bool isDarkMode = false;
  final TextEditingController usernameController = TextEditingController(
      text: "USERNAME");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb5ay974Ak1bGFIDStEQaYK7qK60bzbbmczDft-ao-Xw&s'),
                ),
                SizedBox(width: 30,),
                Column(
                  children: [
                    Text("Welcome,", style: TextStyle(fontSize: 20),),
                    Text("Username"),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20,),
            Card(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: 270,
                child:
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: DropdownButtonFormField<String>(
                              value: language,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Select Language"),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  language = newValue!;
                                });
                              },
                              items: <String>['English', 'Arabic', 'Spanish']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        const Icon(Icons.wb_sunny, color: Colors.orange,),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                        ),
                        const Icon(Icons.nights_stay, color: Colors.black,),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Expanded(
                      child: Card(
                        color: Colors.grey[200],
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Change Username"),
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () => usernameController.text = "USERNAME", child: const Text("Cancel")),
                                  const Spacer(),
                                  TextButton(
                                      onPressed: confirmUsername, child: const Text("Confirm")),
                                ],
                              )
                            ],
                          ),
                        ),
                      
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                height: 100,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                        child: const Row(
                          children: [
                            Icon(Icons.warning, size: 40, color: Colors.red,),
                            Text("DANGER ZONE", style: TextStyle(color: Colors.red),),
                          ],
                        )
                    ),
                    Row(
                      children: [
                        TextButton(onPressed: () => displayWarning(disableAccount),
                            child: const Text("Disable Account")),
                        const Spacer(),
                        TextButton(onPressed: () => displayWarning(deleteAccount),
                            child: const Text("Delete Account")),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void confirmUsername() {
    print("CONFIRMUSERNAME FUNCTION");
  }


  void disableAccount() {
    print("DISABLE FUNCTION");
    Navigator.pop(context);
  }

  void deleteAccount() {
    print("DELETE FUNCTION");
    Navigator.pop(context);
  }

  void displayWarning(void Function() func) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Text("DANGER ZONE", style: TextStyle(color: Colors.red),),
                  content: SizedBox(
                    width: 300,
                    height: 100,
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            Container(margin: const EdgeInsets.only(right: 10),child: const Icon(Icons.warning, color: Colors.red)),
                            const Flexible(
                              child: Text(
                                "Are you sure you want to proceed?",
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                            const Spacer(),
                            TextButton(onPressed: func, child: const Text("Proceed", style: TextStyle(color: Colors.red),)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}
