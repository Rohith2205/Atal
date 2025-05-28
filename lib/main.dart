import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:atl_membership/screens/attendancescreen.dart';
import 'package:atl_membership/screens/homescreen.dart';
import 'package:atl_membership/screens/mainscreen.dart';
import 'package:atl_membership/screens/resourcesscreen.dart';
import 'package:atl_membership/screens/jointeamscreen.dart';
import 'package:atl_membership/screens/teamscreen.dart';
import 'package:atl_membership/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'amplify_outputs.dart';

void main() async{
  try {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent
      )
    );
    WidgetsFlutterBinding.ensureInitialized();
    await _configureAmplify();
    runApp(const MyApp());
  } on AmplifyException catch (e) {
    runApp(Text("Error configuring Amplify: ${e.message}"));
  }
}


Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyConfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Authenticator(
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
            GetPage(name: Routes.HOME, page:()=> const MainScreen(),
            children: [
              GetPage(name: Routes.ATTENDANCE, page: ()=>Attendancescreen()),
              GetPage(name: Routes.HOME, page: ()=>Homescreen()),
              GetPage(name: Routes.RESOURCES, page: ()=>ResourcesScreen()),
              GetPage(name: Routes.JOINTEAM, page: ()=>JoinTeamscreen()),
              GetPage(name: Routes.TEAM, page: ()=>Teamscreen())
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


