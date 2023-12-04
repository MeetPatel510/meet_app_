import 'package:flutter/material.dart';

class PrivacyAndTerms extends StatelessWidget {
  const PrivacyAndTerms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Read our ',
          style: TextStyle(
            color: Colors.grey,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: 'Privacy Policy. ',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            const TextSpan(text: 'Tap "Agree and continue" to accept the '),
            TextSpan(
              text: 'Terms of Services.',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
