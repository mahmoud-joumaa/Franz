import 'package:flutter/material.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(margin: const EdgeInsets.only(right: 50), child: const Text("Rating", style: TextStyle(fontSize: 30))),
              IconButton(onPressed: (){setState(() {rating = 1;});}, icon: Icon(rating > 0 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
              IconButton(onPressed: (){setState(() {rating = 2;});}, icon: Icon(rating > 1 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
              IconButton(onPressed: (){setState(() {rating = 3;});}, icon: Icon(rating > 2 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
              IconButton(onPressed: (){setState(() {rating = 4;});}, icon: Icon(rating > 3 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
              IconButton(onPressed: (){setState(() {rating = 5;});}, icon: Icon(rating > 4 ? Icons.star : Icons.star_border, color: Colors.orange, size: 30,)),
            ],
          ),
          Expanded(
            child: Container(
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
          ),

          TextField(
            controller: messageController,
            maxLines: 13,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Message"),
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
                  onPressed: submit,
                  child: const Text("Submit")
              ),
            ],
          ),
        ],
      ),
    );
  }

  void submit() {

  }
  void reset() {
    setState(() {
      messageController.text = '';
      rating = 0;
    });
  }
}

