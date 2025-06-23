import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:atl_membership/controllers/AuthController.dart';
import 'package:atl_membership/controllers/UserTableController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../services/user_table_amplify_service.dart';


class Policyscreen extends StatefulWidget {
  const Policyscreen({super.key});

  @override
  State<Policyscreen> createState() => _PolicyscreenState();
}

class _PolicyscreenState extends State<Policyscreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading:IconButton(onPressed: (){
              Get.back();
            }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
            title: Text(
              'About ATL Mentorship',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600 ,color: Colors.white),

            ),

          ),
            body: PolicyDialog()));
  }
}

class PolicyDialog extends StatefulWidget {

  @override
  State<PolicyDialog> createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<PolicyDialog> {
  final PdfViewerController _pdfViewerController = PdfViewerController() ;
  late UserController _userController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userController = Get.find<UserController>();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pdfViewerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
                height: Get.height/1.5,
                width: Get.width,
                child: SfPdfViewer.asset('assets/pdfs/ChildProtectionPolicy.pdf',controller: _pdfViewerController,)),
            Obx(
                ()=> OutlinedButton(onPressed: () async {
                if(_userController.isPolicyAccepted.value!= true) {
                  final success = await _userController.acceptPolicy();
                  if (success) {
                    _userController.shouldShowDialog.value = false;
                    if(context.mounted){
                      Navigator.of(context).pop();
                    }
                  }
                }
                },
                  style: OutlinedButton.styleFrom(
                backgroundColor: _userController.isPolicyAccepted.value==false?Colors.blue:Colors.grey
              ), child: Text(
                  _userController.isPolicyAccepted.value==false?"I Agree":"Accepted",style: TextStyle(color: Colors.white),
              )),
            )

          ],
        );
  }
}
