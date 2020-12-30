import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterClean/main/factories/factories.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../ui/components/components.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: 'Clean',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: makeLoginPage),
        GetPage(name: '/surveys', page: () => Scaffold(body: Text('Enquetes')))
      ],
    );
  }
}
