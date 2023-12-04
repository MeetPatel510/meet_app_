// import 'package:meet_app/components/custom_button.dart';
// import 'package:meet_app/screens/auth/login_page.dart';
// import 'package:flutter/material.dart';
//
// class LandingScreen extends StatelessWidget {
//   const LandingScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 50),
//             const Text(
//               'Welcome to WhatsApp',
//               style: TextStyle(
//                 fontSize: 33,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: size.height / 9),
//             Image.asset(
//               'assets/bg.png',
//               height: 340,
//               width: 340,
//               color: Color.fromRGBO(0, 167, 131, 1),
//             ),
//             SizedBox(height: size.height / 9),
//             const Padding(
//               padding: EdgeInsets.all(15.0),
//               child: Text(
//                 'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
//                 style: TextStyle(color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: size.width * 0.75,
//               child: CustomButton(
//                 text: 'AGREE AND CONTINUE',
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: ((context) {
//                         return LoginPage();
//                       })));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:meet_app/screens/auth/login_page.dart';
import 'package:meet_app/screens/landing/widget/elveatedbutton.dart';
import 'package:meet_app/screens/landing/widget/language_button.dart';
import 'package:meet_app/screens/landing/widget/privacy.dart';
import 'package:flutter/material.dart';


class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                child: Image.asset(
                  'assets/circle.png',
                  color: Color(0xFF25D366),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: Column(
                children: [
                  const Text(
                    'Welcome to WhatsApp',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const PrivacyAndTerms(),
                  const LanguageButton(),

                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                            return LoginPage();
                          })));
                    },
                    text: 'AGREE AND CONTINUE',
                  ),
                ],
              ))
        ],
      ),
    );
  }
}