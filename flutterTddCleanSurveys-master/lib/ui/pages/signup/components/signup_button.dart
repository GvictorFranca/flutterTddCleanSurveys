import 'package:flutter/material.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/i18n/i18n.dart';

class SignUpButon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return RaisedButton(
            onPressed: snapshot.data == true ? presenter.signUp : null,
            child: Text(R.string.enter.toUpperCase()),
          );
        });
  }
}
