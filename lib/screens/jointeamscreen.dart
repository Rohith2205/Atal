import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/routes.dart';

class JoinTeamscreen extends StatefulWidget {
  const JoinTeamscreen({super.key});

  @override
  State<JoinTeamscreen> createState() => _JoinTeamscreenState();
}

class _JoinTeamscreenState extends State<JoinTeamscreen> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          leading:IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back,color: Colors.black,size: 40,)) ,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEEF1F5),
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/Emblem_of_Andhra_Pradesh.png'),height: 200,width: 200,),
                Text(
                  'Create team',
                  style: TextStyle(color: Colors.black, fontSize: 32),
                ),
                OutlinedButton(
                  onPressed: () => {Get.offNamed('${Routes.HOME}${Routes.TEAM}')},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Create new team',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: Get.width/3,
                      height: 1,
                      color: Colors.black,
                    ),
                    Text('or'),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: Get.width/3,
                      height: 1,
                      color: Colors.black,
                    ),
                  ],
                ),
                Text(
                  'Find a team',
                  style: TextStyle(color: Colors.black, fontSize: 32),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width/8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue,width:2))
                    ),
                  ),
                ),
                OutlinedButton(onPressed: (){},style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ), child: Text('search',style: TextStyle(color: Colors.white),)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
