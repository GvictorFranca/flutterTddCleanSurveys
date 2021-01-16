import 'package:flutter/material.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Nome',
            icon:
                Icon(Icons.person, color: Theme.of(context).primaryColorLight),
          ),
          keyboardType: TextInputType.name,
          onChanged: presenter.validateName,
        );
      },
    );
  }
}