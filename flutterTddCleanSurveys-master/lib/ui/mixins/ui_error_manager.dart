import 'package:flutter/material.dart';
import 'package:flutterClean/ui/components/components.dart';
import 'package:flutterClean/ui/helpers/errors/errors.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<UIError> stream) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(context, error.description);
      }
    });
  }
}
