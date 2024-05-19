import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import "package:franz/global.dart";

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
        children: [
          const Text("What is AMT?", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Illustrations/florid-window-with-graph.gif", width: 400.0, fit: BoxFit.contain,),
          const Text("AMT is short for Automatic Music Transcription", textAlign: TextAlign.center,),
          const Text("It is the process of transcribing audio into sheet music", textAlign: TextAlign.center,),
        ]
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("What is Franz?", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Illustrations/isometric-machine-learning-for-artificial-intelligence-1.gif", width: 400.0, fit: BoxFit.contain,),
          const Text("Franz is your very own Automatic Music Transcriber!", textAlign: TextAlign.center,),
          const Text("It uses machine learning and a cloud backend to transcribe your favorite songs and tunes", textAlign: TextAlign.center,),
        ]
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Who is Franz?", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Illustrations/martina-man-playing-guitar-music-for-woman.gif", width: 400.0, fit: BoxFit.contain,),
          const Text("\"Franz\" is inspired by Franz Liszt", textAlign: TextAlign.center,),
          const Text("He was a Hungarian composer, vituoso pianist, conductor, and teacher of the Romantic period (19\u0054\u0048 century)", textAlign: TextAlign.center,),
        ]
      ),
    ),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Who are the developers?", style: TextStyle(fontSize: 40.0), textAlign: TextAlign.center,),
          Image.asset("assets/Illustrations/clip-applying-to-university-online.gif", width: 400.0, fit: BoxFit.contain,),
          const Text("That's us! We are a group of 3 undergraduate students with a dream. We decided to code that dream into a reality", textAlign: TextAlign.center,),
          const Text("P.S. We should be graduating soon... Wish us luck!", textAlign: TextAlign.center,),
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
                    onTap: () => launchUrl(Uri.parse("https://github.com/MahmoudJLB/Franz/blob/main/README.md")),
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
