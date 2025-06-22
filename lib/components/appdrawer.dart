import 'package:atl_membership/components/logoutdialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/AuthController.dart';
import '../utils/routes.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key, required this.authController});
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => CircleAvatar(
                          backgroundColor: authController.userController.profileColor.value,
                          radius: 45,
                          child: Center(
                            child: Text(
                              authController.userController.userName.value[0]??"",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 60),
                            ),
                          ),
                        )),
                        Text(
                          'Hello, ${authController.userController.userName.value}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
                const AppdrawerTile(
                    tileName: 'Profile',
                    routeName: '${Routes.HOME}${Routes.PROFILE}'),
                const AppdrawerTile(
                    tileName: 'About',
                    routeName: '${Routes.HOME}${Routes.ABOUT}'),
                const AppdrawerTile(tileName: 'Policies', routeName: '${Routes.HOME}${Routes.POLICY}'),
                const AppdrawerTile(
                    tileName: 'Team',
                    routeName: '${Routes.HOME}${Routes.JOINTEAM}'),
                const AppdrawerTile(
                    tileName: 'School Mapping',
                    routeName: '${Routes.HOME}${Routes.SCHOOL}'),
                const AppdrawerTile(
                    tileName: 'Achievements',
                    routeName: '${Routes.HOME}${Routes.ACHIEVEMENTS}'),
                const AppdrawerTile(
                    tileName: 'Suggestions',
                    routeName: '${Routes.HOME}${Routes.SUGGESTION}'),
                const AppdrawerTile(
                    tileName: 'Help & Support',
                    routeName: '${Routes.HOME}${Routes.HELP}'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100.0, vertical: 20),
                  child: OutlinedButton(
                      onPressed: () {
                        Get.back(closeOverlays: true);
                        logoutDialog(authController, context);
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () async {
              const url = 'https://aim.gov.in/';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch website')),
                );
              }
            },
            title: const Text(
              'Visit Our Website',
              style: TextStyle(fontSize: 24, color: Color(0xFF49454F)),
            ),
            leading: const Icon(Icons.language, color: Color(0xFF49454F)),
          ),
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