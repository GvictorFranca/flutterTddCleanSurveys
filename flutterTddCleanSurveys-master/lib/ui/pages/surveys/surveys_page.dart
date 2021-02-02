import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterClean/ui/mixins/mixins.dart';
import 'package:flutterClean/ui/components/components.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';

class SurveysPage extends StatelessWidget
    with LoadingManager, NavigationManager, SessionManager {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);

          handleSession(presenter.isSessionExpiredStream);

          handleNavigation(presenter.navigateToStream, clear: false);

          presenter.loadData();
          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Provider(
                    create: (_) => presenter,
                    child: SurveyItems(viewModels: snapshot.data));
              }
              return SizedBox(
                height: 0,
              );
            },
          );
        },
      ),
    );
  }
}
