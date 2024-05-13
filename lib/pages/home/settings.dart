import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:franz/global.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = "English";
  bool isDarkMode = false;
  final TextEditingController usernameController = TextEditingController(text: "USERNAME");
  final TextEditingController emailController = TextEditingController(text: "EMAIL");
  final TextEditingController passwordController = TextEditingController(text: "");
  final TextEditingController codeController = TextEditingController(text: "");
  bool _hidePassword = true;
  String preferedInstrument = 'Piano';

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
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb5ay974Ak1bGFIDStEQaYK7qK60bzbbmczDft-ao-Xw&s'),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text(
                      "Welcome,",
                    ),
                    Text(
                      "Username",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                height: 610,
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        alignment: Alignment.centerLeft,
                        child: const Text("General", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                    ),
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
                              items: <String>[
                                'English',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Icon(
                          Icons.wb_sunny,
                          color: Colors.orange,
                        ),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                        ),
                        const Icon(
                          Icons.nights_stay,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        hintText: 'Select item',
                                        border: OutlineInputBorder(),
                                        labelText: "Prefered Instrument Class"
                                      ),
                                      value: preferedInstrument,
                                      // Set the current selected item
                                      onChanged: (String? value) {
                                        setState(() {
                                          preferedInstrument = value!;
                                        });
                                      },
                                      items: Instruments.midiInstruments.keys.toList().map<DropdownMenuItem<String>>((
                                          String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: Colors.grey[200],
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Change Username"),
                                ),
                              ),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Change Email"),
                                ),
                              ),
                              TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  label: const Text("Enter Password"),
                                  suffixIcon: IconButton(icon: _hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off), onPressed: () {setState(() {_hidePassword = !_hidePassword;});})

                                ),
                                obscureText: _hidePassword,
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () =>
                                          usernameController.text = "USERNAME",
                                      child: const Text("Cancel")),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: confirmUsername,
                                    child: const Text("Confirm"),
                                  ),
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
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          alignment: Alignment.centerLeft,
                          child: const Text("Verify Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                      ),
                      TextField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Enter Code"),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: resendCode,
                            child: const Text("Resend Code")),
                          const Spacer(),
                          TextButton(
                            onPressed: verifyAccount,
                            child: const Text("Verify Account")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.warning,
                              size: 40,
                              color: Colors.red,
                            ),
                            Text(
                              "DANGER ZONE",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )),

                        Center(
                          child: TextButton(
                              onPressed: () => displayWarning(deleteAccount),
                              child: const Text("Delete Account")),
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
              title: const Text(
                "DANGER ZONE",
                style: TextStyle(color: Colors.red),
              ),
              content: SizedBox(
                width: 300,
                height: 100,
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            child:
                                const Icon(Icons.warning, color: Colors.red)),
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
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel")),
                        const Spacer(),
                        TextButton(
                            onPressed: func,
                            child: const Text(
                              "Proceed",
                              style: TextStyle(color: Colors.red),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void verifyAccount() {
    print("VERIFY ACCOUNT FUNCTION");
  }

  void resendCode() {
    print("RESEND CODE FUNCTION");
  }
}
