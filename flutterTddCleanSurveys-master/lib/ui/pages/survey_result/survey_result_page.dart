import 'package:flutter/material.dart';
import 'package:flutterClean/ui/components/components.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/mixins/mixins.dart';
import 'package:flutterClean/ui/pages/pages.dart';

import 'components/components.dart';

class SurveyResultPage extends StatelessWidget
    with LoadingManager, SessionManager {
  final SurveyResultPresenter presenter;

  SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys)),
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);

          handleSession(presenter.isSessionExpiredStream);

          presenter.loadData();

          return StreamBuilder<SurveyResultViewModel>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return SurveyResult(viewModel: snapshot.data);
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
