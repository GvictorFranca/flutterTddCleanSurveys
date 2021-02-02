import 'package:flutter/material.dart';
import 'package:flutterClean/ui/mixins/mixins.dart';

import 'splash_presenter.dart';

class SplashPage extends StatelessWidget with NavigationManager {
  final SplashPresenter presenter;

  const SplashPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash'),
      ),
      body: Builder(
        builder: (context) {
          handleNavigation(presenter.navigateToStream, clear: true);
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
