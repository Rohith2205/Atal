import 'package:atl_membership/controllers/AuthController.dart';
import 'package:atl_membership/screens/attendancescreen.dart';
import 'package:atl_membership/screens/homescreen.dart';
import 'package:atl_membership/screens/resourcesscreen.dart';
import 'package:atl_membership/screens/jointeamscreen.dart';
import 'package:atl_membership/screens/teamscreen.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/Bottomnavbar.dart';
import '../components/appdrawer.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late final AuthController _authController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController = Get.put(AuthController());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _authController.dispose();
    super.dispose();
  }

  final List<Widget> widgetOptions = const [
    Attendancescreen(),
    HomeScreen(),
    Resourcesscreen(),
    JoinTeamscreen(),
    Teamscreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (kDebugMode) {
      print(index);
      print(Get.currentRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffEEF1F5),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(36))),
          title: const Text(
            'ATL Mentorship',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => {_scaffoldKey.currentState?.openDrawer()},
            icon: ImageIcon(
              AssetImage('assets/icons/menu.png'),
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => {
                ElegantNotification(
                  description: Text("No Notifications"),
                ).show(context)
              },
              icon: ImageIcon(
                AssetImage('assets/icons/notification.png'),
                color: Colors.white,
              ),
            ),
          ],
        ),
        drawer: Drawer(child: AppDrawerWidget(authController: _authController,)),
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavbarWidget(
          selectedIndex: _selectedIndex,
          onTappedItem: _onItemTapped,
        ),
      ),
    );
  }
}