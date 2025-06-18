import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:atl_membership/components/personaldetails.dart';
import 'package:atl_membership/screens/profilescreen.dart';
import 'package:atl_membership/screens/resourcesscreen.dart';
import 'package:atl_membership/screens/schoolscreen.dart';
import 'package:atl_membership/screens/suggestionscreen.dart';
import 'package:atl_membership/screens/teamscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../utils/routes.dart';
import 'aboutscreen.dart';
import 'achievementsscreen.dart';
import 'attendancescreen.dart';
import 'help_support.dart';
import 'homescreen.dart';
import 'jointeamscreen.dart';
import 'mainscreen.dart';

class Sign extends StatelessWidget {
  const Sign({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Authenticator(
        dialCodeOptions: const DialCodeOptions(defaultDialCode: DialCode.in1),
        authenticatorBuilder: (BuildContext context, AuthenticatorState state){
          switch(state.currentStep){
            case AuthenticatorStep.signIn: return AuthScaffold(state: state,
                body: SignInForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signUp,
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],

              ),

            );
            case AuthenticatorStep.signUp: return AuthScaffold(state: state,
                body: SignUpForm.custom(fields: [
                  SignUpFormField.name(required: true),
                  SignUpFormField.email(required: true),
                  SignUpFormField.phoneNumber(required: true),
                  SignUpFormField.password(),
                  SignUpFormField.passwordConfirmation()
                ]),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(
                      AuthenticatorStep.signIn,
                    ),
                    child: const Text('Sign In'),
                  ),
                ],
              ),

            );
            case AuthenticatorStep.confirmSignUp: return AuthScaffold(state: state,
                body: ConfirmSignUpForm()
            );
            default : null;
          }
          return null;
        },
        child: GetMaterialApp(
          initialRoute: Routes.HOME,
          getPages: [
            // GetPage(name: Routes.PERSONAL, page: ()=>PersonalDetailsDialog()),
            GetPage(name: Routes.HOME, page:()=> const MainScreen(),
            children: [
              GetPage(name: Routes.ATTENDANCE, page: ()=>Attendancescreen()),
              GetPage(name: Routes.HOME, page: ()=>HomeScreen()),
              GetPage(name: Routes.RESOURCES, page: ()=>Resourcesscreen()),
              GetPage(name: Routes.JOINTEAM, page: ()=>JoinTeamscreen()),
              GetPage(name: Routes.TEAM, page: ()=>Teamscreen()),
              GetPage(name: Routes.PROFILE, page: ()=>Profilescreen()),
              GetPage(name: Routes.ABOUT, page: ()=>Aboutscreen()),
              GetPage(name: Routes.SCHOOL, page: ()=>Schoolscreen()),
              GetPage(name: Routes.ACHIEVEMENTS, page: ()=>Achievementsscreen()),
              GetPage(name: Routes.SUGGESTION, page: ()=>Suggestionscreen()),
              GetPage(name: Routes.HELP, page: ()=>HelpSupportscreen()),
            ]
            ),
          ],
          theme: ThemeData(colorSchemeSeed: Colors.blue),
      debugShowCheckedModeBanner: false,
      builder: Authenticator.builder(),
    ));
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;
  static const String assetName = 'assets/images/Emblem_of_Andhra_Pradesh.png';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App logo
               Padding(
                padding: EdgeInsets.only(top: 32),
                child: Center(child: Image.asset(assetName,height: 175,width: 175,)),
              ),
              SizedBox(height: 50,),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: body,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: footer != null ? [footer!] : null,
    );
  }
}

