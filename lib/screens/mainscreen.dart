import 'package:atl_membership/controllers/AuthController.dart';
import 'package:atl_membership/screens/attendancescreen.dart';
import 'package:atl_membership/screens/homescreen.dart';
import 'package:atl_membership/screens/resourcesscreen.dart';
import 'package:atl_membership/screens/jointeamscreen.dart';
import 'package:atl_membership/screens/teamscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/routes.dart';


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
    Homescreen(),
    ResourcesScreen(),
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
              onPressed: () => {},
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

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key, required this.authController});
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.only(left: 15, top: 15),
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(color: Colors.blue),

            // height: MediaQuery.of(context).size.height/4.5,
            // width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(()=>CircleAvatar(
                  backgroundColor: authController.profileColor.value,
                  radius: 45,
                  child: Center(
                    child: Text(
                      'M',
                      style: TextStyle(color: Colors.white, fontSize: 60),
                    ),
                  ),
                )),
                Text(
                  'Hello, Mahesh...',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: (){
              Get.back(closeOverlays: true);
              Get.toNamed('${Routes.HOME}${Routes.JOINTEAM}');
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => JoinTeamscreen()));
              },
            title: Text(
              'Team',
              style: TextStyle(fontSize: 24, color: Color(0xFF49454F)),
            ),
            // selected: true,
            // tileColor: Color(0xFFE6E6E6),
          ),
        ],
      ),
    );
  }
}