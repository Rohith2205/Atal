// widgets/atl_widgets.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ATLWidgets {

  // Header illustration widget
  static Widget buildHeaderIllustration() {
    return Container(
      height: 200,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue[100]!, Colors.purple[100]!]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(top: 20, left: 20, child: buildIcon(Icons.lightbulb, Colors.orange, 40)),
          Positioned(top: 30, right: 30, child: buildIcon(Icons.play_arrow, Colors.purple[300]!, 80, 50)),
          Positioned(bottom: 20, left: 30, child: buildIcon(Icons.book, Colors.blue[300]!, 60, 40)),
          Positioned(bottom: 30, right: 40, child: buildIcon(Icons.school, Colors.teal[300]!, 70, 45)),
        ],
      ),
    );
  }

  // Icon widget builder
  static Widget buildIcon(IconData icon, Color color, double width, [double? height]) {
    return Container(
      width: width,
      height: height ?? width,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(width == height ? width / 2 : 8)
      ),
      child: Icon(icon, color: Colors.white, size: width * 0.6),
    );
  }

  // Level button widget with customizable title
  static Widget buildLevelButton({
    required String title,
    required bool isExpanded,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isExpanded ? Colors.blue[600] : Colors.white,
          foregroundColor: isExpanded ? Colors.white : Colors.black,
          elevation: isExpanded ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isExpanded ? Colors.blue[600]! : Colors.grey[300]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: Duration(milliseconds: 300),
              child: Icon(Icons.expand_more, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  // Sub-level buttons builder
  static List<Widget> buildSubLevelButtons({
    required List<Map<String, String>> subLevels,
    required Function(String) onSubLevelPressed,
  }) {
    return subLevels.map((subLevel) => Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.only(left: 20, right: 0, top: 3, bottom: 3),
      child: ElevatedButton(
        onPressed: () => onSubLevelPressed(subLevel['url']!),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black87,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.play_circle_outline, size: 20, color: Colors.blue[600]),
            SizedBox(width: 12),
            Text(subLevel['title']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    )).toList();
  }

  // URL launcher helper
  static Future<void> launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}

