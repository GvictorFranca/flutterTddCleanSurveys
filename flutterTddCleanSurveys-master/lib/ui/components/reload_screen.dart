import 'package:flutter/material.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  const ReloadScreen({
    @required this.error,
    @required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, left: 58),
      child: Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error,
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                onPressed: reload,
                child: Text(
                  R.string.reload,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
