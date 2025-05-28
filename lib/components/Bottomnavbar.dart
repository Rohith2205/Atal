import 'package:flutter/material.dart';

class BottomNavbarWidget extends StatelessWidget {
  const BottomNavbarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTappedItem,
  });

  final int selectedIndex;
  final void Function(int)? onTappedItem;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      // unselectedItemColor: Colors.blueGrey,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/Checklist.png')),
          label: 'Attendance',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/Books.png'), size: 40),
          label: 'Resources',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onTappedItem,
    );
  }
}