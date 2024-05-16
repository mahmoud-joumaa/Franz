// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:franz/global.dart';
import 'package:franz/services/authn_service.dart';
import 'package:franz/pages/home/about.dart';
import 'package:franz/pages/home/contact.dart';
import 'package:franz/pages/home/settings.dart';
import 'package:franz/pages/home/transcribe.dart';
import 'package:franz/pages/home/new_transcription.dart';

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});

  final String title;

  // Currently logged in user =====================================================================
  static User? user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    // Initialzie proper user attributes
    fetchUserAttributes(MyHomePage.user!).then((res) {
      for (final attribute in res["attributes"]) {
        switch (attribute.getName()) {
          case "email":
            MyHomePage.user!.email = attribute.getValue();
            break;
          case "profile":
            MyHomePage.user!.profileUrl = attribute.getValue();
            break;
          case "custom:preferred_instrument":
            MyHomePage.user!.preferredInstrument = attribute.getValue();
            break;
        }
      }
    });
  }

  int currentPageIndex = 1;

  Widget _buildBody() {
    switch (currentPageIndex) {
      case 0:
        return const SettingsScreen();
      case 1:
        return const TranscribeScreen();
      case 2:
        return const ContactScreen();
      case 3:
        return const AboutScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              dynamic result = await signOutCurrentUser(MyHomePage.user!);
              if (result["success"]) {
                Alert.show(
                  context,
                  result["message"],
                  "",
                  UserTheme.isDark ? Colors.greenAccent[700]! : Colors.greenAccent[300]!,
                  "logout"
                );
              }
              else {
                Alert.show(
                  context,
                  "Error Logging Out",
                  result["message"],
                  UserTheme.isDark ? Colors.greenAccent[700]! : Colors.greenAccent[300]!,
                  "dismiss"
                );
              }
            },
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: currentPageIndex == 1,
        maintainSize: false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewTransScreen(),
              ),
            );
          },
          tooltip: 'Transcribe',
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.music_note),
            icon: Icon(Icons.music_note_outlined),
            label: 'Transcription',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.mail),
            icon: Icon(Icons.mail_outline),
            label: 'Contact',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

}
