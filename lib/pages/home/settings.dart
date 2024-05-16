import 'package:flutter/material.dart';
import 'package:franz/global.dart';
import 'package:franz/pages/home/home.dart';
import 'package:franz/services/authn_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = "English";
  bool isDarkMode = false;
  String? email = MyHomePage.user?.email;
  String? username = MyHomePage.user?.authDetails.username;
  final TextEditingController usernameController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "EMAIL");
  final TextEditingController passwordController = TextEditingController(text: "");
  final TextEditingController codeController = TextEditingController(text: "");
  bool _hidePassword = true;
  String preferedInstrument = 'Piano';

  void initState(){
    super.initState();
    usernameController.text = username!;
    emailController.text = email!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar( // TODO: Get from cognito
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb5ay974Ak1bGFIDStEQaYK7qK60bzbbmczDft-ao-Xw&s'),
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    const Text(
                      "Welcome,",
                    ),
                    Text(
                      username!,
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
                    // ignore: sized_box_for_whitespace
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
                                        labelText: "Preferred Instrument Class",
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
                                enabled: false,
                              ),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Change Email"),
                                ),
                                enabled: false,
                              ),
                              TextField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  label: const Text("Enter Password"),
                                  suffixIcon: IconButton(icon: _hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off), onPressed: () {setState(() {_hidePassword = !_hidePassword;});})

                                ),
                                obscureText: _hidePassword,
                                enabled: false,
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
                              onPressed: () async {
                                await deleteAccount(context);
                              },
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
  }


  deleteAccount(context) async {
    final result = await deleteUser(MyHomePage.user!);
    if (result["success"]) {
      Alert.show(
        context,
        "User Deleted Successfully",
        "",
        UserTheme.isDark ? Colors.greenAccent[700]! : Colors.greenAccent[100]!,
        "logout"
      );
    }
    else {
      Alert.show(
        context,
        "Error Logging Out",
        result["message"],
        UserTheme.isDark ? Colors.greenAccent[700]! : Colors.greenAccent[100]!,
        "dismiss"
      );
    }
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

}
