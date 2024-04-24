import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Text("Contact Us"),
          ),

          TextFormField(
            maxLines: 10,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              TextButton(
                  onPressed: submit,
                  child: const Text("Submit")
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  void submit() {
  }
}