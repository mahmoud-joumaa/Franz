import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import "package:franz/config.dart";

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  final PageController _controller = PageController(); // keep track of what page the user is on
  int i = 0; // current page

  final intros = [
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // FIXME: Change text and illustration images of each child
        children: [
          const Text("Text", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Franz.jpg", width: 400.0, fit: BoxFit.contain,),
          const Text("Text", textAlign: TextAlign.center,),
          const Text("Text", textAlign: TextAlign.center,),
        ]
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Text", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Franz.jpg", width: 400.0, fit: BoxFit.contain,),
          const Text("Text", textAlign: TextAlign.center,),
          const Text("Text", textAlign: TextAlign.center,),
        ]
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Balance your Craves", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Franz.jpg", width: 400.0, fit: BoxFit.contain,),
          const Text("Balanced Craves helps you track your diet by standards YOU set!", textAlign: TextAlign.center,),
          const Text("Your progress is private to you and you alone", textAlign: TextAlign.center,),
        ]
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Text", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Franz.jpg", width: 400.0, fit: BoxFit.contain,),
          const Text("Text", textAlign: TextAlign.center,),
          const Text("Text", textAlign: TextAlign.center,),
        ]
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Text", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Franz.jpg", width: 400.0, fit: BoxFit.contain,),
          const Text("Text", textAlign: TextAlign.center,),
          const Text("Text", textAlign: TextAlign.center,),
        ]
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          NotificationListener<OverscrollIndicatorNotification>( // allow infinite scroll as a loop
            onNotification: ((notification) {
              setState(() {_controller.animateToPage(i == 0 ? 5 : 0, duration: const Duration(milliseconds: 1200), curve: Curves.easeIn);});
              return true;
            }),
            child: PageView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {i = index;},
              children: [
                ...intros,
              ],
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Previous
                IconButton(
                  onPressed: () {
                    if (i == 0) {
                      _controller.animateToPage(intros.length-1, duration: const Duration(milliseconds: 1200), curve: Curves.easeIn);
                    }
                    else {
                      _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                // Indicators
                SmoothPageIndicator(
                  controller: _controller,
                  count: intros.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 15.0,
                    dotWidth: 15.0,
                    spacing: 10.0,
                    // dotColor: UserTheme.isDark ? const Color(Palette.white).withOpacity(0.85) : const Color(Palette.grey).withOpacity(0.85),
                    activeDotColor: UserTheme.isDark ? Colors.deepPurple[400]! : Colors.deepPurple[900]!,
                  ),
                ),
                // Next
                IconButton(
                  onPressed: () {
                    if (i == intros.length-1) {
                      _controller.animateToPage(0, duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);
                    }
                    else {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ]
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Illustrations provided by ", style: TextStyle(color: Color(Palette.grey))),
                  InkWell(
                    child: const Text("icons8", style: TextStyle(color: Color(Palette.grey), decoration: TextDecoration.underline,)),
                    onTap: () => launchUrl(Uri.parse("https://icons8.com/")),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Check ", style: TextStyle(color: Color(Palette.grey))),
                  InkWell(
                    child: const Text("Readme.md", style: TextStyle(color: Color(Palette.grey), decoration: TextDecoration.underline,)),
                    onTap: () => launchUrl(Uri.parse("https://icons8.com/")), // FIXME: Fix URL
                  ),
                  const Text(" for detailed references", style: TextStyle(color: Color(Palette.grey))),
                ],
              ),
            ]
          ),
        ],
      ),
    );
  }
}
