import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportscreen extends StatelessWidget {
  const HelpSupportscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading:IconButton(onPressed: (){
              Get.back();
            }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
            title: const Text('Help & Support',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600 ,color: Colors.white)
            ),
          ),
          backgroundColor: Color(0xffeef1f5),
          body:
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(child: SvgPicture.asset('assets/images/About.svg' ,height: 200,width: 200,)),
                  SizedBox(height: 15,),
                  Text('Regarding any issues,contact us,',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30,

                      letterSpacing: 1.5,
                      wordSpacing: 3.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10,),
                  InkWell(
                    onTap: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'atlmentor.ap@gmail.com',
                        query: Uri.encodeFull('subject=Support Request'),
                      );
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open email app')),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.email, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'support-atl-mentorship@gmail.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          )
      );
  }
}
