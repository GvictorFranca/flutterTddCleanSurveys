import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome',
        icon: Icon(Icons.person, color: Theme.of(context).primaryColorLight),
      ),
      keyboardType: TextInputType.name,
    );
  }
}
