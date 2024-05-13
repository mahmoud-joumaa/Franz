// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:franz/global.dart';
import 'package:franz/services/authn_service.dart';

import 'package:franz/pages/home/about.dart';
import 'package:franz/pages/home/contact.dart';
import 'package:franz/pages/home/settings.dart';
import 'package:franz/pages/home/transcribe.dart';
import 'package:franz/pages/home/new_transcription.dart';

/* ================================================================================================
Currently logged in user start
================================================================================================ */

// TODO: Add user credentials from login screen

/* ================================================================================================
Currently logged in user end
================================================================================================ */

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
              // FIXME: Fix after handling user credentials from login screen
              /*
              dynamic result = await signOutCurrentUser();
              if (result["success"]) {
                Alert.show(
                  context,
                  result["message"],
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
              */
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
