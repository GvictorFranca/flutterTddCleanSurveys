import 'package:flutter/material.dart';
import 'package:flutterClean/utils/i18n/i18n.dart';

import '../../components/components.dart';
import 'components/components.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currectFocus = FocusScope.of(context);
      if (!currectFocus.hasPrimaryFocus) {
        currectFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LoginHeader(),
                  Headline1(text: 'SignUp'),
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          NameInput(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: EmailInput(),
                          ),
                          PasswordInput(),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordConfirmationInput(),
                          ),
                          SignUpButon(),
                          FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.exit_to_app),
                              label: Text(R.strings.addAccount))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
