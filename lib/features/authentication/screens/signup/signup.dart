import 'package:flutter/material.dart';
import 'package:utrack/utils/constants/text_strings.dart';
import 'package:utrack/utils/formatters/icons.dart';
import 'package:utrack/utils/themes/custom_themes/sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(Usizes.defaultSpace),
            child: Column(
              children: [
                ///Title
                Text(UTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),

                ///Form
                Form(child: Column(
                  children: [
                    Row(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: UTexts.firstName, prefixIcon: UIcons.user()),
                        )
                      ],
                    )
                  ]
                )
                )
              ],
            )
        ),
      )
    );
  }
}

