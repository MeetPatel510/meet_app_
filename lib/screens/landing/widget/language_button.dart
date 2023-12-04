import 'package:meet_app/screens/landing/widget/cutome_icone_button.dart';
import 'package:flutter/material.dart';


class LanguageButton extends StatelessWidget {
  const LanguageButton({Key? key}) : super(key: key);

  showBottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.grey!.withOpacity(.4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  CustomIconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.close,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'App Language',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: .5,
                color: Colors.grey!.withOpacity(.3),
              ),
              RadioListTile(
                value: true,
                groupValue: true,
                onChanged: (value) {},
                activeColor: Colors.teal,
                title: const Text('English'),
                subtitle: Text(
                  "(Phone's language)",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              RadioListTile(
                value: true,
                groupValue: false,
                onChanged: (value) {},
                activeColor: Colors.teal,
                title: const Text('አማርኛ'),
                subtitle: Text(
                  "Amharic",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF7F8FA),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => showBottomSheet(context),
        borderRadius: BorderRadius.circular(20),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Color(0xFFE8E8ED),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.language,
                color: Colors.teal,
              ),
              SizedBox(width: 10),
              Text(
                'English',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
