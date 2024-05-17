// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:franz/global.dart';
import 'package:franz/pages/home/home.dart';
import 'package:franz/services/authn_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = "English";
  String? email = MyHomePage.user?.email;
  String? username = MyHomePage.user?.authDetails.username;
  final TextEditingController usernameController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "EMAIL");
  final TextEditingController passwordController = TextEditingController(text: "");
  final TextEditingController codeController = TextEditingController(text: "");
  bool _hidePassword = true;
  late String preferredInstrument;
  // ignore: non_constant_identifier_names
  List<String> instrument_classes = Instruments.midiInstruments.keys.toList();


  @override
  void initState(){
    super.initState();
    usernameController.text = username!;
    emailController.text = email!;
    instrument_classes.add('None');

    if(MyHomePage.user?.preferredInstrument != 'None'){
      preferredInstrument = MyHomePage.user!.preferredInstrument!;
    }
    else{
      preferredInstrument = Instruments.midiInstruments.keys.toList().first;
    }

  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = UserTheme.isDark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController controller = TextEditingController(text: MyHomePage.user!.profileUrl);
                        return AlertDialog(
                          title: const Text("Enter URL of new image"),
                          content: TextField(
                            controller: controller,
                          ),
                          actions: [
                            IconButton(
                              onPressed: () async {
                                await updateUserAttribute(MyHomePage.user!, "profile", controller.text);
                                setState(() { MyHomePage.user!.profileUrl = controller.text; });
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.check)
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(MyHomePage.user!.profileUrl ?? "https://i.pinimg.com/736x/cb/2c/53/cb2c538ff848a8b6f9162d20cc0e32d0.jpg"),
                  ),
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
                      style: const TextStyle(fontSize: 20),
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
                              // onChanged: (String? newValue) {
                              //   setState(() {
                              //     language = newValue!;
                              //   });
                              // },
                              onChanged: null,
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
                              Provider.of<UserTheme>(context, listen: false).toggleTheme(value);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Row(
                                      children: [
                                        Icon(UserTheme.isDark?Icons.dark_mode:Icons.light_mode),
                                        const SizedBox(width: 10.0),
                                        Text("Applied ${UserTheme.isDark?'Dark':'Light'} Theme", style: const TextStyle(fontSize: 15.0)),
                                      ]
                                    ),
                                  );
                                },
                              );
                            });
                          },
                        ),
                        Icon(
                          Icons.nights_stay,
                          color: !UserTheme.isDark ? Colors.black : Colors.white,
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
                                        labelText: "Preferred Instrument Class"

                                      ),
                                      value: preferredInstrument,
                                      // Set the current selected item
                                      onChanged: (String? value) {
                                        setState(() async {
                                          await updateUserAttribute(MyHomePage.user!, "custom:preferred_instrument", value!);
                                          preferredInstrument = value;
                                          MyHomePage.user?.preferredInstrument = preferredInstrument;
                                        });
                                      },
                                      items: instrument_classes.map<DropdownMenuItem<String>>((
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
                                      onPressed: () {},
                                          // usernameController.text = "USERNAME",
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
    Alert.load(context);
    final result = await deleteUser(MyHomePage.user!);
    Navigator.of(context).pop();
    if (result["success"]) {
      Alert.show(
        context,
        "User Deleted Successfully",
        "",
        UserTheme.isDark ? Colors.green[700]! : Colors.green[300]!,
        "logout"
      );
    }
    else {
      Alert.show(
        context,
        "Error Logging Out",
        result["message"],
        UserTheme.isDark ? Colors.green[700]! : Colors.green[300]!,
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
