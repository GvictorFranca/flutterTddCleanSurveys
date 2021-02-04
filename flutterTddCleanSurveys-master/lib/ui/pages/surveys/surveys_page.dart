import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterClean/ui/mixins/mixins.dart';
import 'package:flutterClean/ui/components/components.dart';
import 'package:flutterClean/ui/helpers/helpers.dart';
import 'package:flutterClean/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'components/components.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingManager, NavigationManager, SessionManager, RouteAware {
  @override
  Widget build(BuildContext context) {
    final routeObserver = Get.find<RouteObserver>();
    routeObserver.subscribe(this, ModalRoute.of(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.surveys),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.presenter.isLoadingStream);

          handleSession(widget.presenter.isSessionExpiredStream);

          handleNavigation(widget.presenter.navigateToStream, clear: false);

          widget.presenter.loadData();
          return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: widget.presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Provider(
                    create: (_) => widget.presenter,
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

  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  void dispose() {
    final routeObserver = Get.find<RouteObserver>();
    routeObserver.unsubscribe(this);

    super.dispose();
  }
}
