import 'package:flutter/material.dart';

import 'package:franz/registration.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Franz",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Welcome(),
    )
  );
}
