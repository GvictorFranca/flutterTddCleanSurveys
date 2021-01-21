import 'package:flutter/material.dart';
import 'package:flutterClean/main/factories/factories.dart';
import 'package:flutterClean/ui/pages/pages.dart';

Widget makeSignUpPage() {
  return SignUpPage(makeGetxSignUpPresenter());
}
