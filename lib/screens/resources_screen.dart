import 'package:flutter/material.dart';
import 'resources_widgets.dart';

class Resources_screen extends StatefulWidget {
  const Resources_screen({super.key});

  @override
  State<Resources_screen> createState() => _Resources_screenState();
}

class _Resources_screenState extends State<Resources_screen> {
  int? _expandedLevel;

  final Map<int, List<Map<String, String>>> _levelData = {
    1: [
      {'title': 'Equipment Manual', 'url': 'https://drive.google.com/file/d/1PRForMGBFrejCDi0i4UvX3Auk8K4xccS/view?usp=sharing'},
    ],
    2: [
      {'title': 'Electronics ppt - I', 'url': 'https://docs.google.com/presentation/d/1TlFQ-TureSL_WstiJ1y8TrfWoRhYsfMu/edit?usp=sharing&ouid=109763324838352162584&rtpof=true&sd=true'},
      {'title': 'Electronics ppt - II', 'url': 'https://docs.google.com/presentation/d/1HjAYXxtyV1y-r9sry5pPk-A_7Flo_qrZ/edit?usp=sharing&ouid=109763324838352162584&rtpof=true&sd=true'},
    ],

    3: [
      {'title': 'Session 1', 'url': 'https://docs.google.com/presentation/d/1pWKVd9-KUB0YubHqxKcZGtiXaRdzRnpo/edit?usp=sharing&ouid=109763324838352162584&rtpof=true&sd=true'},
      {'title': 'Session 2', 'url': 'https://docs.google.com/presentation/d/1Wl5x_3fI-RU3k_UCfdrO4NTrgNFSLyej/edit?usp=sharing&ouid=109763324838352162584&rtpof=true&sd=true'},
    ],
    4: [
      {'title': 'Activity Card', 'url': 'https://drive.google.com/file/d/1IdsEBr3ozNtAJ4oCaa5BvonCiCVZt51q/view?usp=sharing'},
      {'title': 'DT template', 'url': 'https://docs.google.com/document/d/1VFxh-rpXmft3K2AOhG1ukdNTHyQ2O-JH/edit?usp=sharing&ouid=109763324838352162584&rtpof=true&sd=true'},
      {'title': 'Identifying problems', 'url': 'https://docs.google.com/presentation/d/158F6c-LStnqQ720s1x4A1HzY5SQZ31eT/edit?usp=sharing&ouid=109763324838352162584&rtpof=true&sd=true'},
    ],
    5: [
      {'title': 'Safety', 'url': 'https://sites.google.com/view/understanding-safety'},
    ],
    6: [
      {'title': 'Tools', 'url': 'https://sites.google.com/view/tools-in-atl'},
    ],
    7: [
      {'title': 'Raspberry Pi', 'url': 'https://sites.google.com/view/r-pi'},
    ],
  };

  // Custom level titles - you can modify these as needed
  final Map<int, String> _levelTitles = {
    1: 'ATL Equipment Manual',
    2: 'Circuit Education',
    3: '3D Printing',
    4: 'Design Thinking',
    5: 'Safety',
    6: 'Tools',
    7: 'Raspberry Pi',
  };

  void _toggleLevel(int level) {
    setState(() {
      _expandedLevel = _expandedLevel == level ? null : level;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Resources',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/images/resources.jpg',
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          for (int level = 1; level <= 7; level++) ...[
            // Using separated level button widget with custom title
            ATLWidgets.buildLevelButton(
              title: _levelTitles[level] ?? 'Level $level',
              isExpanded: _expandedLevel == level,
              onPressed: () => _toggleLevel(level),
            ),

            // Using separated sub-level buttons widget
            if (_expandedLevel == level)
              ...ATLWidgets.buildSubLevelButtons(
                subLevels: _levelData[level] ?? [],
                onSubLevelPressed: (url) => ATLWidgets.launchURL(url, context),
              ),

            SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}