import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/AuthController.dart';
import '../utils/routes.dart';

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
          AppdrawerTile(tileName: 'Team',routeName: '${Routes.HOME}${Routes.JOINTEAM}'),
        ],
      ),
    );
  }
}

class AppdrawerTile extends StatelessWidget {
  const AppdrawerTile({
    super.key,required this.tileName, required this.routeName,
  });

  final String routeName;
  final String tileName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Get.back(closeOverlays: true);
        Get.toNamed(routeName);
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => JoinTeamscreen()));
      },
      title: Text(
        tileName,
        style: TextStyle(fontSize: 24, color: Color(0xFF49454F)),
      ),
      // selected: true,
      // tileColor: Color(0xFFE6E6E6),
    );
  }
}