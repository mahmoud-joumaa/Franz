// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:franz/global.dart';
import 'package:open_mail_app/open_mail_app.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  int rating = 0;
  final TextEditingController messageController = TextEditingController();
  String category = "Provide Feedback";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topCenter,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Rating", style: TextStyle(fontSize: 30)),
                const Spacer(),
                IconButton(onPressed: (){setState(() {rating = 1;});}, icon: Icon(rating > 0 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
                IconButton(onPressed: (){setState(() {rating = 2;});}, icon: Icon(rating > 1 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
                IconButton(onPressed: (){setState(() {rating = 3;});}, icon: Icon(rating > 2 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
                IconButton(onPressed: (){setState(() {rating = 4;});}, icon: Icon(rating > 3 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
                IconButton(onPressed: (){setState(() {rating = 5;});}, icon: Icon(rating > 4 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            alignment: Alignment.centerLeft,
            child: DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Message Type"),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  category = newValue!;
                });
              },
              items: <String>['Report Bug', 'Provide Feedback', 'Suggest Feature']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: TextField(
              controller: messageController,
              maxLines: 100,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Message"),
              ),
            ),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: reset,
                  child: const Text("Reset",)
              ),
              const Spacer(),
              TextButton(
                  onPressed: () async { await submit(context); },
                  child: const Text("Submit")
              ),
            ],
          ),
        ],
      ),
    );
  }

  submit(context) async {
    // Get number of stars based of rating
    String ratingStars = "";
    for (int i = 0; i < rating; i++) { ratingStars += '⭐'; }
    // Generate email
    EmailContent email = EmailContent(to: ['franz.transcriber@gmail.com'], subject: 'Franz $category', body: 'Rating: $ratingStars\n\n${messageController.text}');
    // Choose email client
    OpenMailAppResult result = await OpenMailApp.composeNewEmailInMailApp(nativePickerTitle: 'Select email app to compose', emailContent: email);
    if (!result.didOpen && !result.canOpen) {
      Alert.show(
        context,
        "Failed to Open Mail App",
        "No installed mail apps were found",
        UserTheme.isDark ? Colors.redAccent[700]! : Colors.redAccent[100]!,
        "dismiss",
      );
    }
    else if (!result.didOpen && result.canOpen) {
      showDialog(
        context: context,
        builder: (_) => MailAppPickerDialog(
          mailApps: result.options,
          emailContent: email,
        ),
      );
    }
  }

  void reset() {
    setState(() {
      messageController.text = '';
      rating = 0;
    });
  }

}
