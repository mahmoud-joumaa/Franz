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
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-psd/psd-old-paper-scroll-ancient-papyrus-isolated-background_1409-3501.jpg?w=740&t=st=1713952057~exp=1713952657~hmac=ce56805bc7ce6b65963748c164242610cf2b034a1cb55f3c20e51b9d8962eb08'),
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
              child: Column(
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
                  Card(
                    color: Colors.grey[200],
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Change Username"),
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () => usernameController.text = "USERNAME", child: Text("Cancel")),
                              const Spacer(),
                              TextButton(
                                  onPressed: confirmUsername, child: Text("Confirm")),
                            ],
                          )
                        ],
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Card(
              child: Column(
                children: [
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.warning, size: 40, color: Colors.red,),
                          Text("DANGER ZONE", style: TextStyle(color: Colors.red),),
                        ],
                      )
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      TextButton(onPressed: () => displayWarning(disableAccount),
                          child: Text("Disable Account")),
                      Spacer(),
                      TextButton(onPressed: () => displayWarning(deleteAccount),
                          child: Text("Delete Account")),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
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
                  title: const Text("DANGER ZONE"),
                  content: Container(
                    width: 300,
                    height: 100,
                    child: Column(
                      children: [
                        Spacer(),
                        const Row(
                          children: [
                            Icon(Icons.warning),
                            Text(
                              "Are you sure you want to proceed?"
                            ),
                          ],
                        ),
                        Spacer(),
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
