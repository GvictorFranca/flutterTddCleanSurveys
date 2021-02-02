import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterClean/ui/components/components.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';

class SurveysPage extends StatelessWidget {
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
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          presenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired == true) {
              Get.offAllNamed('/login');
            }
          });

          presenter.navigateToStream.listen((page) {
            if (page?.isNotEmpty == true) {
              Get.toNamed(page);
            }
          });

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
